-- lua/plugins/completion.lua
-- LSP-only completion. No snippet plugins, no path source, no buffer-word spam.
-- Snippet expansion uses the built-in vim.snippet (needed because clangd
-- returns function completions in snippet format for arg placeholders).

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")
      local completion_kinds = require("cmp.types").lsp.CompletionItemKind

      cmp.setup({
        completion = {
          -- Stay quiet on the first character; LSP trigger characters such as
          -- `.` still open member completion immediately.
          keyword_length = 2,
        },
        preselect = cmp.PreselectMode.None,

        sources = cmp.config.sources({
          {
            name = "nvim_lsp", -- syntax and symbols known to the active LSP
            max_item_count = 12,
            entry_filter = function(entry)
              -- Generic Text entries are usually prose/noise rather than code.
              return completion_kinds[entry:get_kind()] ~= "Text"
            end,
          },
        }),

        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },

        -- Clean bordered menu + docs window
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        experimental = {
          ghost_text = false,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<C-d>"]     = cmp.mapping.scroll_docs(4),
          ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
          -- Enter confirms only if you actually selected something;
          -- otherwise it's a plain newline. No surprise completions.
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.snippet.active({ direction = 1 }) then
              vim.snippet.jump(1) -- Tab through clangd arg placeholders
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.snippet.active({ direction = -1 }) then
              vim.snippet.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        formatting = {
          fields = { "abbr", "kind" },
          format = function(_, item)
            item.menu = nil -- no source label clutter; there's only one source
            return item
          end,
        },
      })
    end,
  },
}
