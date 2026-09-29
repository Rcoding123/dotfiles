-- lua/config/lazy.lua
-- Bootstrap lazy.nvim, then load every spec in lua/plugins/

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "quietlab" } },
  checker = { enabled = false },          -- no auto update-nagging
  change_detection = { notify = false },
  rocks = { enabled = false },            -- no plugin needs luarocks; skip hererocks
  ui = { border = "rounded" },
})
