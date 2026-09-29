-- Render Markdown inside Neovim while keeping the source editable.

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      html = { enabled = false },
      latex = { enabled = false },
      yaml = { enabled = false },
    },
    keys = {
      { "<leader>tm", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle Markdown rendering" },
    },
  },
}
