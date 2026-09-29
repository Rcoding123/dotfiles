-- lua/plugins/oil.lua
-- Press - to open the parent directory as an editable buffer.
-- Rename/delete/create files like editing text, :w to apply.

return {
  {
    "stevearc/oil.nvim",
    lazy = false, -- must load at startup to hijack `nvim <dir>` from netrw
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
    },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = false, -- toggle in-buffer with g.
      },
    },
  },
}
