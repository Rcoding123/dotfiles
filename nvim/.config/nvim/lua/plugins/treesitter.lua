-- Neovim 0.12 uses the rewritten nvim-treesitter API from the main branch.

local parsers = {
  "c",
  "cpp",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "bash",
  "cmake",
  "make",
  "python",
  "markdown",
  "markdown_inline",
  "diff",
  "gitcommit",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})

      local missing = {}
      for _, parser in ipairs(parsers) do
        if not pcall(vim.treesitter.language.inspect, parser) then
          missing[#missing + 1] = parser
        end
      end
      if #missing > 0 then
        treesitter.install(missing)
      end

      local group = vim.api.nvim_create_augroup("fc_treesitter", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "*",
        callback = function(event)
          if not pcall(vim.treesitter.start, event.buf) then
            return
          end

          -- Keep Python's native indenter because it respects manual dedents.
          if vim.bo[event.buf].filetype ~= "python" then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
