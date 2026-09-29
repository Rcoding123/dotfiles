-- lua/plugins/autopairs.lua
-- Auto-close (), [], {}, "", ''. Treesitter-aware: won't pair inside
-- strings/comments where it doesn't make sense.
-- Note: no cmp confirm-hook on purpose -- clangd already inserts
-- parens + arg placeholders via snippet completions; hooking both
-- double-parenthesizes.

return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- treesitter integration
    },
  },
}
