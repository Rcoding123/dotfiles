-- lua/plugins/telescope.lua

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",   desc = "Grep project" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Grep word under cursor" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",     desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>",    desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",   desc = "Help" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics (search)" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>",  desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>",     desc = "Keymaps" },
      { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in buffer" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = "> ",
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
          },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })
      telescope.load_extension("fzf")
    end,
  },
}
