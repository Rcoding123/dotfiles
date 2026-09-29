#!/usr/bin/env bash
# bootstrap.sh - provision a fresh Debian/Ubuntu box from this dotfiles repo.
#
#   curl -fsSL https://raw.githubusercontent.com/Rcoding123/dotfiles/main/bootstrap.sh | bash
#
# Order: apt packages (incl. gh) -> gh auth -> Neovim release tarball ->
# dotfiles via stow + plugin restore -> gh git credential helper -> Claude Code ->
# claude-agent-kit-linux install + doctor.
#
# Secrets are prompted on the terminal, or read from the environment for
# unattended runs (cloud-init). Neither is ever written into this repo.
#   GH_PAT        fine-grained GitHub PAT (Contents: read/write on the repos you need)
#   CLAUDE_TOKEN  output of `claude setup-token`
# A secret is only asked for when that step is not already configured, so a
# re-run is an update, not a re-provision.
#
# Optional overrides: DOTFILES_REPO, DOTFILES_DIR, KIT_REPO, KIT_DIR.
#
# Everything lives in functions and `main` is called on the last line, so a
# download truncated mid-pipe executes nothing.

set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-Rcoding123/dotfiles}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
KIT_REPO="${KIT_REPO:-Rcoding123/claude-agent-kit-linux}"
KIT_DIR="${KIT_DIR:-$HOME/src/claude-agent-kit-linux}"
CLAUDE_ENV="$HOME/.config/claude-env"
BIN_DIR="$HOME/.local/bin"
OPT_DIR="$HOME/.local/opt"

APT_PACKAGES=(
  build-essential ca-certificates curl git gh jq stow tmux unzip tar
  python3 python3-venv python3-pip nodejs npm
)

TMP_DIR=""

log()  { printf '\n==> %s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }

cleanup() { [[ -n $TMP_DIR ]] && rm -rf -- "$TMP_DIR"; return 0; }

# gh prefers GH_TOKEN/GITHUB_TOKEN over its stored login. Strip them so status
# checks and login reflect what is actually persisted on this box.
ghx() { env -u GH_TOKEN -u GITHUB_TOKEN gh "$@"; }

# read_secret VAR PROMPT - keep VAR from the environment, else prompt on the
# terminal. stdin is the curl pipe, so the prompt must read /dev/tty.
read_secret() {
  local var=$1 prompt=$2 value=""
  [[ -n ${!var:-} ]] && return 0
  if ! { exec 3</dev/tty; } 2>/dev/null; then
    die "$var is not set and there is no terminal to prompt on"
  fi
  read -rsp "$prompt: " value <&3 || true
  exec 3<&-
  printf '\n' >&2
  [[ -n $value ]] || die "$var is empty"
  printf -v "$var" '%s' "$value"
}

gh_logged_in() {
  command -v gh >/dev/null 2>&1 && ghx auth status --hostname github.com >/dev/null 2>&1
}

preflight() {
  [[ $EUID -ne 0 ]] || die "run as your normal user, not root (it uses sudo only for apt)"
  command -v apt-get >/dev/null 2>&1 || die "this script supports Debian/Ubuntu (apt) only"
  sudo -n true 2>/dev/null || sudo -v || die "sudo is required for apt"

  # Secrets from the environment must not leak into every child process.
  export -n GH_PAT CLAUDE_TOKEN 2>/dev/null || true

  # Ask for everything up front so an interactive run is not interrupted
  # after the slow apt step.
  if ! gh_logged_in; then
    read_secret GH_PAT "GitHub fine-grained PAT"
  fi
  if [[ ! -s $CLAUDE_ENV ]]; then
    read_secret CLAUDE_TOKEN "Claude token (from 'claude setup-token')"
  fi

  mkdir -p "$BIN_DIR" "$OPT_DIR"
  case ":$PATH:" in *":$BIN_DIR:"*) ;; *) PATH="$BIN_DIR:$PATH" ;; esac
  TMP_DIR="$(mktemp -d)"
  trap cleanup EXIT
}

install_apt() {
  log "apt packages (with the GitHub CLI repository)"
  local keyring=/etc/apt/keyrings/githubcli-archive-keyring.gpg
  local list=/etc/apt/sources.list.d/github-cli.list
  if [[ ! -s $keyring || ! -f $list ]]; then
    sudo install -d -m 755 /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo tee "$keyring" >/dev/null
    sudo chmod go+r "$keyring"
    printf 'deb [arch=%s signed-by=%s] https://cli.github.com/packages stable main\n' \
      "$(dpkg --print-architecture)" "$keyring" | sudo tee "$list" >/dev/null
  fi
  sudo env DEBIAN_FRONTEND=noninteractive apt-get update -qq
  sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    --no-install-recommends "${APT_PACKAGES[@]}"
}

gh_login() {
  log "GitHub CLI auth"
  if [[ -n ${GH_PAT:-} ]]; then
    printf '%s\n' "$GH_PAT" \
      | ghx auth login --hostname github.com --git-protocol https --with-token
    unset GH_PAT
  fi
  ghx auth status --hostname github.com
}

install_nvim() {
  log "Neovim (latest release tarball)"
  local arch asset tag digest current=""
  case "$(uname -m)" in
    x86_64)        arch=x86_64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) die "no Neovim tarball for $(uname -m)" ;;
  esac
  asset="nvim-linux-$arch.tar.gz"

  read -r tag digest < <(ghx api repos/neovim/neovim/releases/latest \
    --jq "[.tag_name, (.assets[] | select(.name == \"$asset\") | .digest)] | @tsv")
  [[ -n $tag && $digest == sha256:* ]] || die "could not resolve $asset digest for latest Neovim"

  if [[ -x $BIN_DIR/nvim ]]; then
    current="$("$BIN_DIR/nvim" --version | awk 'NR==1 {print $2}')"
  fi
  if [[ $current == "$tag" ]]; then
    printf 'nvim %s already installed\n' "$tag"
    return 0
  fi

  curl -fsSL -o "$TMP_DIR/$asset" \
    "https://github.com/neovim/neovim/releases/download/$tag/$asset"
  # GitHub's asset digest catches a corrupted or swapped download; it does not
  # vouch for the release itself.
  printf '%s  %s\n' "${digest#sha256:}" "$TMP_DIR/$asset" | sha256sum --check --quiet \
    || die "sha256 mismatch for $asset"

  rm -rf -- "$OPT_DIR/nvim.new"
  mkdir -p "$OPT_DIR/nvim.new"
  tar -xzf "$TMP_DIR/$asset" -C "$OPT_DIR/nvim.new" --strip-components=1
  rm -rf -- "$OPT_DIR/nvim"
  mv "$OPT_DIR/nvim.new" "$OPT_DIR/nvim"
  ln -sfn "$OPT_DIR/nvim/bin/nvim" "$BIN_DIR/nvim"
  "$BIN_DIR/nvim" --version | head -n 1
}

# Move aside any real file stow would refuse to replace. Targets that already
# resolve into the repo (a previous run) are left alone.
backup_conflicts() {
  local pkg=$1 backup=$2 rel target
  while IFS= read -r -d '' rel; do
    rel=${rel#./}
    target="$HOME/$rel"
    [[ -e $target || -L $target ]] || continue
    [[ $(readlink -f -- "$target") == "$(readlink -f -- "$DOTFILES_DIR/$pkg/$rel")" ]] && continue
    mkdir -p -- "$backup/$(dirname -- "$rel")"
    mv -- "$target" "$backup/$rel"
    printf 'backed up ~/%s -> %s\n' "$rel" "$backup/$rel"
  done < <(cd "$DOTFILES_DIR/$pkg" && find . \( -type f -o -type l \) -print0)
}

install_dotfiles() {
  log "dotfiles ($DOTFILES_REPO -> $DOTFILES_DIR)"
  if [[ -d $DOTFILES_DIR/.git ]]; then
    git -C "$DOTFILES_DIR" pull --ff-only \
      || warn "dotfiles has diverged locally; skipped pull"
  else
    ghx repo clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi

  local backup pkg name
  backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
  for pkg in "$DOTFILES_DIR"/*/; do
    name="$(basename -- "$pkg")"
    backup_conflicts "$name" "$backup"
    stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$name"
    printf 'stowed %s\n' "$name"
  done

  if [[ -f $HOME/.config/nvim/init.lua ]]; then
    log "Neovim plugins (lazy.nvim, pinned by lazy-lock.json)"
    "$BIN_DIR/nvim" --headless "+Lazy! restore" +qa \
      || warn "plugin restore reported errors; open nvim and run :Lazy"
  fi
}

# Runs after stow: `gh auth setup-git` writes `git config --global`, and
# GIT_CONFIG_GLOBAL points that at an untracked local file instead of the
# stowed ~/.gitconfig, which includes it.
gh_setup_git() {
  log "git credential helper"
  touch "$HOME/.gitconfig.local"
  GIT_CONFIG_GLOBAL="$HOME/.gitconfig.local" ghx auth setup-git --hostname github.com
}

install_bashrc_block() {
  local begin='# >>> bootstrap.sh >>>' end='# <<< bootstrap.sh <<<'
  touch "$HOME/.bashrc"
  grep -qxF "$begin" "$HOME/.bashrc" && return 0
  cat >> "$HOME/.bashrc" <<EOF

$begin
case ":\$PATH:" in *":\$HOME/.local/bin:"*) ;; *) PATH="\$HOME/.local/bin:\$PATH" ;; esac
[ -r "\$HOME/.config/claude-env" ] && . "\$HOME/.config/claude-env"
$end
EOF
}

install_claude() {
  log "Claude Code"
  if command -v claude >/dev/null 2>&1; then
    claude update || warn "claude update failed; keeping the installed version"
  else
    curl -fsSL https://claude.ai/install.sh | bash
  fi

  if [[ -n ${CLAUDE_TOKEN:-} ]]; then
    mkdir -p "$(dirname -- "$CLAUDE_ENV")"
    (umask 077 && printf 'export CLAUDE_CODE_OAUTH_TOKEN=%q\n' "$CLAUDE_TOKEN" > "$CLAUDE_ENV.tmp")
    mv -- "$CLAUDE_ENV.tmp" "$CLAUDE_ENV"
    chmod 600 "$CLAUDE_ENV"
    unset CLAUDE_TOKEN
    printf 'token stored in %s (mode 600)\n' "$CLAUDE_ENV"
  fi
  install_bashrc_block
}

install_kit() {
  log "claude-agent-kit ($KIT_REPO -> $KIT_DIR)"
  if [[ -d $KIT_DIR/.git ]]; then
    git -C "$KIT_DIR" pull --ff-only || warn "kit has diverged locally; skipped pull"
  else
    mkdir -p -- "$(dirname -- "$KIT_DIR")"
    ghx repo clone "$KIT_REPO" "$KIT_DIR"
  fi
  "$KIT_DIR/install.sh"
  log "kit doctor"
  "$KIT_DIR/install.sh" doctor
}

main() {
  preflight
  install_apt
  gh_login
  install_nvim
  install_dotfiles
  gh_setup_git
  install_claude
  install_kit
  log "done. Open a new shell (or: source ~/.bashrc), then fully restart Claude Code."
}

main "$@"
