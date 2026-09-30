#!/usr/bin/env bash
# bootstrap.sh - machine layer for a fresh Ubuntu 24.04 box:
#   packages -> hardening -> GitHub SSH -> gh CLI -> Neovim -> dotfiles
#   -> Claude Code -> claude-agent-kit-linux
# Idempotent: re-running updates in place. Project setup (VBT, MCP, backups)
# lives in the research repo's own scripts/bootstrap.sh, not here.
#
# Run as your normal sudo user (not root), pinned to a commit:
#   bash <(curl -fsSL https://raw.githubusercontent.com/Rcoding123/dotfiles/<commit-sha>/bootstrap.sh)
#
# Secrets never live in this repo. Env var or terminal prompt:
#   CLAUDE_CODE_OAUTH_TOKEN  from `claude setup-token`; prompted only if not yet configured
#                            (ROTATE_CLAUDE_TOKEN=1 to replace it)
#   GITHUB_PAT               optional, fine-grained, only for the gh CLI.
#                            Git itself uses this box's SSH key.
set -euo pipefail

GH_USER="Rcoding123"
GIT_NAME="${GIT_NAME:-Ronak}"
GIT_EMAIL="${GIT_EMAIL:-${GH_USER}@users.noreply.github.com}"
NVIM_VERSION="${NVIM_VERSION:-v0.12.5}"   # pinned; bump deliberately
UV_VERSION="${UV_VERSION:-0.12.21}"       # pinned; bump deliberately
DOTFILES_REPO="git@github.com:${GH_USER}/dotfiles.git"
KIT_REPO="git@github.com:${GH_USER}/claude-agent-kit-linux.git"
SRC="$HOME/src"
STOW_PKGS=(nvim tmux)   # git identity is set below, so .gitconfig is not stowed
GITHUB_ED25519_FP="SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU"
ME="$(id -un)"

log() { printf '\n==> %s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
tty_pause() {
  [[ -r /dev/tty ]] || die "no terminal available for: $1"
  read -rp "$1" _ </dev/tty
}
ask_secret() {  # ask_secret VAR "prompt" - reads /dev/tty because stdin may be the script
  local var="$1"
  if [[ -z "${!var:-}" ]]; then
    [[ -r /dev/tty ]] || die "$var not set and no terminal to prompt on"
    read -rsp "$2: " "${var?}" </dev/tty
    echo >/dev/tty
  fi
}
clone_or_pull() {  # clone_or_pull <ssh-url> <dest>
  if [[ -d "$2/.git" ]]; then git -C "$2" pull --ff-only; else git clone "$1" "$2"; fi
}
github_ssh_ok() {  # ssh -T exits 1 even on success, so test its output, not its status
  local out
  out="$(ssh -T -o BatchMode=yes git@github.com 2>&1 || true)"
  [[ "$out" == *"successfully authenticated"* ]]
}

[[ $EUID -ne 0 ]] || die "run as your normal sudo user, not root"
sudo -v

# --- 1. packages --------------------------------------------------------------
log "apt packages"
export DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a
sudo -E apt-get update -qq
sudo -E apt-get install -y -qq \
  git curl ca-certificates jq tmux htop ripgrep fd-find build-essential unzip stow \
  clangd cmake ninja-build sqlite3 restic ufw openssh-server

mkdir -p "$HOME/.local/bin" "$HOME/.local/opt" "$SRC"
export PATH="$HOME/.local/bin:$PATH"
# shellcheck disable=SC2016  # literal $HOME/$PATH are intended in .bashrc
grep -qs 'HOME/.local/bin' "$HOME/.bashrc" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"

if [[ "$(uv --version 2>/dev/null)" != "uv ${UV_VERSION}"* ]]; then
  log "uv ${UV_VERSION}"
  curl -LsSf "https://astral.sh/uv/${UV_VERSION}/install.sh" | sh
fi

# --- 2. hardening -------------------------------------------------------------
log "hardening"
if [[ -s "$HOME/.ssh/authorized_keys" ]]; then
  sudo tee /etc/ssh/sshd_config.d/00-hardening.conf >/dev/null <<EOF
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
AllowUsers ${ME}
EOF
  sudo sshd -t
  sudo systemctl restart ssh
else
  echo "SKIPPED sshd lockdown: ~/.ssh/authorized_keys is empty (would lock you out)"
fi
sudo ufw default deny incoming >/dev/null
sudo ufw default allow outgoing >/dev/null
sudo ufw limit OpenSSH >/dev/null
sudo ufw --force enable >/dev/null
for unit in ModemManager.service udisks2.service upower.service multipathd.service multipathd.socket; do
  sudo systemctl disable --now "$unit" >/dev/null 2>&1 || true
done
sudo timedatectl set-timezone Etc/UTC

# --- 3. GitHub over SSH -------------------------------------------------------
log "GitHub SSH"
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
if ! ssh-keygen -F github.com >/dev/null 2>&1; then
  scan="$(ssh-keyscan -t ed25519 github.com 2>/dev/null)"
  fp="$(printf '%s\n' "$scan" | ssh-keygen -lf - | awk '{print $2}')"
  [[ "$fp" == "$GITHUB_ED25519_FP" ]] || die "github.com host key mismatch (got $fp)"
  printf '%s\n' "$scan" >> "$HOME/.ssh/known_hosts"
fi
[[ -f "$HOME/.ssh/id_ed25519" ]] || ssh-keygen -q -t ed25519 -C "$(hostname)" -f "$HOME/.ssh/id_ed25519" -N ""
until github_ssh_ok; do
  printf '\nAdd this key at https://github.com/settings/ssh/new (title: %s):\n' "$(hostname)"
  cat "$HOME/.ssh/id_ed25519.pub"
  tty_pause "Press Enter once it is added... "
done

git config --global user.name  "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main
git config --global pull.ff only

# --- 4. GitHub CLI (optional auth) --------------------------------------------
if ! command -v gh >/dev/null; then
  log "GitHub CLI"
  sudo mkdir -p -m 755 /etc/apt/keyrings
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo -E apt-get update -qq
  sudo -E apt-get install -y -qq gh
fi
gh config set git_protocol ssh
if ! gh auth status >/dev/null 2>&1; then
  if [[ -n "${GITHUB_PAT:-}" ]]; then
    printf '%s' "$GITHUB_PAT" | env -u GH_TOKEN gh auth login --hostname github.com --with-token
  else
    echo "gh CLI not authenticated (optional). Later: GITHUB_PAT=... re-run, or gh auth login"
  fi
fi

# --- 5. Neovim ----------------------------------------------------------------
case "$(uname -m)" in
  x86_64)  NV_ARCH=x86_64 ;;
  aarch64) NV_ARCH=arm64 ;;
  *) die "unsupported arch $(uname -m)" ;;
esac
if [[ "$(nvim --version 2>/dev/null | head -n1)" != "NVIM ${NVIM_VERSION}" ]]; then
  log "Neovim ${NVIM_VERSION}"
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/nvim.tgz" \
    "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-${NV_ARCH}.tar.gz"
  rm -rf "$HOME/.local/opt/nvim"
  mkdir -p "$HOME/.local/opt/nvim"
  tar -xzf "$tmp/nvim.tgz" -C "$HOME/.local/opt/nvim" --strip-components=1
  ln -sf "$HOME/.local/opt/nvim/bin/nvim" "$HOME/.local/bin/nvim"
  rm -rf "$tmp"
fi

# --- 6. dotfiles --------------------------------------------------------------
log "dotfiles"
clone_or_pull "$DOTFILES_REPO" "$HOME/dotfiles"
for pkg in "${STOW_PKGS[@]}"; do
  if [[ -d "$HOME/dotfiles/$pkg" ]]; then
    stow -d "$HOME/dotfiles" -t "$HOME" --restow "$pkg"
  fi
done
nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 || true   # lazy.nvim; no-op otherwise

# --- 7. Claude Code -----------------------------------------------------------
log "Claude Code"
command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash
CLAUDE_ENV="$HOME/.config/claude-env"
if [[ ! -s "$CLAUDE_ENV" || "${ROTATE_CLAUDE_TOKEN:-0}" == 1 ]]; then
  ask_secret CLAUDE_CODE_OAUTH_TOKEN "Claude Code OAuth token (from: claude setup-token)"
  mkdir -p "$HOME/.config"
  install -m 600 /dev/null "$CLAUDE_ENV"
  printf 'export CLAUDE_CODE_OAUTH_TOKEN=%q\n' "$CLAUDE_CODE_OAUTH_TOKEN" > "$CLAUDE_ENV"
fi
grep -qs 'claude-env' "$HOME/.bashrc" \
  || echo '[ -f ~/.config/claude-env ] && . ~/.config/claude-env' >> "$HOME/.bashrc"

# --- 8. agent kit -------------------------------------------------------------
log "claude-agent-kit-linux"
clone_or_pull "$KIT_REPO" "$SRC/claude-agent-kit-linux"
( cd "$SRC/claude-agent-kit-linux" && ./install.sh && ./install.sh doctor )

log "done. Open a new shell, then check: nvim --version; claude --version; sudo ufw status"
