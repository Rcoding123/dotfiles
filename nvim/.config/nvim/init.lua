-- ~/.config/nvim/init.lua
-- Neovim config entry point. Load order matters:
-- options (sets leader) -> colorscheme -> plugins -> keymaps -> autocmds

if vim.fn.has("nvim-0.11") == 0 then
  error("This config requires Neovim >= 0.11. You are on "
    .. tostring(vim.version()) .. ". Ubuntu's apt neovim is too old -- "
    .. "install the official tarball or snap (see README).")
end

require("config.options")
vim.cmd.colorscheme("ghostwire")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
