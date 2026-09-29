-- lua/plugins/gitsigns.lua

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(buf)
        -- jupytext.nvim presents an .ipynb file as converted Markdown in the
        -- buffer, so gitsigns would calculate hunks against different text.
        if vim.api.nvim_buf_get_name(buf):match("%.ipynb$") then
          return false
        end

        local gs = require("gitsigns")
        local function bmap(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end

        -- Navigation
        bmap("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
        bmap("n", "[h", function() gs.nav_hunk("prev") end, "Previous hunk")

        -- Actions
        bmap("n", "<leader>hs", gs.stage_hunk,   "Stage hunk")
        bmap("n", "<leader>hr", gs.reset_hunk,   "Reset hunk")
        bmap("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        bmap("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        bmap("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        bmap("n", "<leader>hd", gs.diffthis,     "Diff against index")
        bmap("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle inline blame")
      end,
    },
  },
}
