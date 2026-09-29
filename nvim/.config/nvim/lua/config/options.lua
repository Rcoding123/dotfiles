-- lua/config/options.lua
-- Leader must be set before lazy.nvim loads
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Neovim's Python host and the Jupyter kernel come from the existing
-- data-science environment. NVIM_PYTHON can override this without editing the
-- config if the environment is moved later.
local notebook_python = vim.env.NVIM_PYTHON
  or "/home/ron/miniforge3/envs/data-science/bin/python"
if vim.fn.executable(notebook_python) == 1 then
  vim.g.python3_host_prog = notebook_python

  -- jupytext.nvim's health check looks up `jupytext` on PATH even when the
  -- plugin itself is configured with an absolute path. Append (rather than
  -- prepend) the environment so existing system/LSP tool precedence stays put.
  local notebook_bin = vim.fn.fnamemodify(notebook_python, ":h")
  local path = vim.env.PATH or ""
  if not vim.list_contains(vim.split(path, ":", { plain = true }), notebook_bin) then
    vim.env.PATH = path .. ":" .. notebook_bin
  end
end

local o = vim.opt

-- Indentation: 4-space, C/C++ style. clangd + .clang-format override per-project.
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.expandtab = true
o.shiftround = true -- round indent to multiple of shiftwidth

-- Neovim's Python indent script defaults to two indentation levels after an
-- opening parenthesis. Use one level so multiline calls and containers match
-- the standard four-space hanging-indent style used by Ruff.
vim.g.python_indent = {
  open_paren = "shiftwidth()",
  nested_paren = "shiftwidth()",
  continue = "shiftwidth()",
  closed_paren_align_last_line = false,
}

-- UI
o.number = true
o.relativenumber = true -- relative jumps: 5j / 12k
o.signcolumn = "yes"    -- no layout shift when diagnostics appear
o.cursorline = true
o.termguicolors = true
o.laststatus = 3       -- one statusline across all splits
o.showmode = false     -- lualine already displays the current mode
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.pumheight = 12        -- completion menu max height
o.winborder = "rounded" -- clean rounded borders on floats (nvim >= 0.11)
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }

-- Keep code unfolded by default; zc/zo still provide Tree-sitter-aware folding.
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true
o.foldcolumn = "1"
o.fillchars:append({ eob = " ", fold = " ", foldopen = "▾", foldclose = "▸", foldsep = " " })

-- Search
o.ignorecase = true
o.smartcase = true      -- case-sensitive only if query has capitals
o.inccommand = "split"  -- live preview for :s/.../.../

-- Splits
o.splitright = true
o.splitbelow = true

-- Files
o.undofile = true       -- persistent undo across sessions
o.swapfile = false
o.confirm = true        -- ask instead of failing on unsaved quit

-- Behavior
o.updatetime = 250
o.timeoutlen = 400      -- which-key popup delay
o.completeopt = { "menu", "menuone", "noselect" }
o.mouse = "a"
o.clipboard = "unnamedplus" -- system clipboard; needs wl-clipboard on Wayland
