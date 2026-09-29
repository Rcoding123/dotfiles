# nvim — clean Python/C++ config

Modular Neovim config. Cyber-ops `ghostwire` theme with three built-in alternatives,
lazy.nvim, LSP with mason auto-install,
LSP-only completion, Telescope, treesitter, gitsigns, oil, autopairs,
in-buffer Markdown rendering, and a Jupyter notebook workflow backed by the
existing `data-science` environment.

## Structure

```
nvim/
├── init.lua                  entry point
├── colors/
│   ├── ghostwire.lua         default blue-black operations-desk theme
│   ├── quietlab.lua          calm coding alternative
│   ├── fourcolor.lua         high-contrast four-color base/theme
│   └── turboblue.lua         retro blue alternative
└── lua/
    ├── config/
    │   ├── options.lua       core settings (4-space indent, etc.)
    │   ├── keymaps.lua       global maps
    │   ├── autocmds.lua      yank flash, position restore, make-tabs
    │   └── lazy.lua          plugin manager bootstrap
    └── plugins/
        ├── lsp.lua           mason + clangd/lua_ls/bashls/cmake
        ├── debugger.lua      on-demand Python/C++ debugger and UI
        ├── completion.lua    nvim-cmp, LSP source ONLY
        ├── telescope.lua     fuzzy finder, double-line frames
        ├── treesitter.lua    highlighting + indent
        ├── gitsigns.lua      hunk signs/staging/blame
        ├── oil.lua           file manager ( - to open)
        ├── autopairs.lua     bracket auto-close
        ├── markdown.lua      rendered Markdown view inside Neovim
        ├── notebooks.lua     Jupytext + Quarto/Otter + Molten/Jupyter
        └── ui.lua            lualine, indent guides, which-key, trouble
```

## Requirements

**Neovim ≥ 0.12.** The debugger integration requires the 0.12 line. Ubuntu's
packaged build is kept as a fallback; the official build is the active one:

```sh
# Official tarball (recommended)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
source ~/.bashrc
nvim --version   # verify >= 0.11
```

Or, one command via snap: `sudo snap install nvim --classic`

## Dependencies (Ubuntu)

```sh
sudo apt update
sudo apt install -y git build-essential curl unzip ripgrep fd-find \
  nodejs npm python3 python3-pip python3-venv wl-clipboard xclip

# Ubuntu names the fd binary 'fdfind'; give it its real name
mkdir -p ~/.local/bin && ln -sf "$(which fdfind)" ~/.local/bin/fd
```

- `ripgrep` / `fd-find` — Telescope grep and file finding
- `build-essential` — compiles telescope-fzf-native and treesitter parsers
- `nodejs/npm` — mason installs bashls via npm (if bashls fails to
  install in `:Mason`, apt's Node is too old — get Node 20+ via NodeSource or nvm)
- `python3-venv` — mason installs cmake-language-server into a venv;
  Ubuntu blocks bare pip installs without this (PEP 668)
- `wl-clipboard` + `xclip` — clipboard on Wayland and X11 sessions;
  nvim picks the right one

Notebook support uses `/home/ron/miniforge3/envs/data-science`. It requires
`pynvim`, `jupytext`, `jupyter_client`, `ipykernel`, and `nbformat` in that
environment. To use a moved or renamed environment, set `NVIM_PYTHON` to its
Python executable before starting Neovim.

## Install

```sh
# back up any existing config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
mv ~/.local/state/nvim ~/.local/state/nvim.bak 2>/dev/null

# drop this config in
cp -r nvim ~/.config/nvim

nvim
```

First launch: lazy.nvim bootstraps itself, installs all plugins, mason
downloads the four LSP servers, treesitter compiles parsers. Give it a
minute, then restart. Check health with `:checkhealth` and `:Mason`.

## clangd on your projects

For full project intelligence (cross-file completion, includes, references),
clangd needs `compile_commands.json`:

```sh
cmake -B build -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -sf build/compile_commands.json .
```

Formatting (`<leader>cf`) uses your project's `.clang-format`, falling back
to LLVM style.

## Keymaps (leader = Space)

| Key | Action |
|---|---|
| `<leader>ff` / `fg` / `fb` / `fr` | find files / grep project / buffers / recent |
| `<leader>fs` / `fS` | document / workspace symbols |
| `<leader>/` | fuzzy search in current buffer |
| `gd` / `gr` / `gi` / `gD` | definition / references / implementation / declaration |
| `K` | hover docs |
| `<leader>rn` / `ca` / `cf` | rename / code action / format |
| `<leader>ch` | switch source ↔ header (clangd) |
| `<leader>e` | line diagnostics float |
| `<leader>xx` / `xX` | project / buffer diagnostics (Trouble) |
| `[d` `]d` | prev/next diagnostic (built-in) |
| `-` | file manager (oil) — edit dirs like text, `:w` applies |
| `]h` `[h` | next/prev git hunk |
| `<leader>hs` / `hr` / `hp` / `hb` | stage / reset / preview / blame hunk |
| `<leader>th` | toggle clangd inlay hints (types, param names) |
| `<leader>tb` | toggle inline git blame |
| `<leader>tm` | toggle rendered Markdown view |
| `<leader>tt` | cycle quietlab / fourcolor / turboblue |
| `<C-h/j/k/l>` | window navigation |
| `<S-h>` `<S-l>` | prev/next buffer |
| `<A-j>` `<A-k>` (visual) | move lines |
| `<C-s>` | save |

### Debugging

The debugger interface opens only while a session is active. It shows local
variables, watches, call stacks, breakpoints, a console, and a REPL.

| Key | Action |
|---|---|
| `F5` | start / continue |
| `F9` | toggle breakpoint |
| `F10` / `F11` / `Shift-F11` | step over / into / out |
| `<leader>du` | toggle debugger UI |
| `<leader>de` | evaluate symbol or visual selection |
| `<leader>dr` | toggle debugger REPL |
| `<leader>dx` | terminate session |

## Jupyter notebooks

Open a notebook normally:

```sh
nvim analysis.ipynb
```

The buffer is readable Markdown, while `:write` updates the real `.ipynb`
file and preserves its metadata and saved outputs. Start the existing Python
kernel with `<leader>mi`, then use:

| Key | Action |
|---|---|
| `Shift+Enter` | run the current cell and move to the next Python cell |
| `Ctrl+Enter` | run the current cell and stay in place |
| `<leader>rc` | run the current code cell |
| `<leader>ra` / `rb` | run the current cell and all above / below |
| `<leader>rA` | run every Python cell |
| `<leader>rl` | run the current line |
| `<leader>r` (visual) | run the selection |
| `<leader>mo` / `mh` | open / hide the current output |
| `<leader>mx` | interrupt running code |
| `<leader>mr` / `mq` | restart / stop the kernel |

Text, tables, tracebacks, and other textual results appear below cells as
virtual text. Inline plots are intentionally disabled because they require a
terminal-specific image backend; `:MoltenImagePopup` opens a plot in the
system image viewer when needed.

Completion: type → menu appears (LSP only) → `Tab`/`S-Tab` to select,
`Enter` to accept, `Tab` again jumps through function arg placeholders.
`Enter` with nothing selected is just a newline — no surprise insertions.

## Theme

`colors/ghostwire.lua` is the default: a blue-black operations-desk palette
with cyan control flow, magenta calls, green strings, amber values, and blue
types. `quietlab`, `fourcolor`, and `turboblue` remain available. Press
`<leader>tt` to try all four during the current session.

- cyan — keywords and control flow
- magenta — functions
- green — strings
- amber — numbers, constants, and warnings
- blue — types
- muted blue-gray — comments, line numbers, borders, and inactive UI

Floats use clean rounded borders. The editor UI uses ordinary Unicode symbols;
a Nerd Font is optional and only affects file icons.
