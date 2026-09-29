-- lua/config/keymaps.lua
-- Global maps. Plugin/LSP maps live in their plugin specs.

local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Keep cursor centered on jumps
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Visual mode: stay in visual after indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move selected lines up/down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Paste over selection without clobbering the register
map("x", "<leader>p", [["_dP]], { desc = "Paste, keep register" })

-- Quick save
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Cycle among the local themes without editing the config.
map("n", "<leader>tt", function()
  local themes = { "ghostwire", "quietlab", "fourcolor", "turboblue" }
  local current = vim.g.colors_name or themes[1]
  local index = vim.fn.index(themes, current)
  local next_theme = themes[(index + 1) % #themes + 1]
  vim.cmd.colorscheme(next_theme)
  vim.notify("Theme: " .. next_theme)
end, { desc = "Cycle color theme" })

-- Terminal: double-Esc to leave insert
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostics (list views come from Trouble; these are inline)
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
