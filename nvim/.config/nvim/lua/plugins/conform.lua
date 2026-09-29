-- lua/plugins/conform.lua
-- Dedicated formatter plugin, separate from LSP. clangd already formats C++
-- fine via vim.lsp.buf.format, but pyright has no formatter at all -- ruff
-- does, so Python needs its own path. <leader>cf in lsp.lua picks whichever
-- one applies per filetype.

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" }, -- lazy-load on first save attempt
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        -- ruff_fix runs `ruff check --fix-only` first (safe auto-fixes:
        -- unused imports, etc -- semantic, changes code), then
        -- ruff_organize_imports sorts/dedupes imports, then ruff_format
        -- does pure style (spacing/quotes/line breaks). One keymap, both
        -- lint-fix and format, in that order.
        python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
      },
      -- On save, run only Ruff's style formatter for Python. Keep lint fixes
      -- and import removal behind the explicit <leader>cf command so saving a
      -- half-written lesson cannot change its behavior or remove new imports.
      format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "python" then
          return {
            formatters = { "ruff_format" },
            timeout_ms = 1000,
            lsp_format = "never",
          }
        end
      end,
    },
  },
}
