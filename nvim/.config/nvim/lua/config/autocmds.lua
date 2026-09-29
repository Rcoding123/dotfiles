-- lua/config/autocmds.lua

local aug = function(name)
  return vim.api.nvim_create_augroup("fc_" .. name, { clear = true })
end

-- Flash yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug("yank"),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 120 })
  end,
})

-- Reopen file at last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = aug("lastpos"),
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lines = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Makefiles need real tabs
vim.api.nvim_create_autocmd("FileType", {
  group = aug("make_tabs"),
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

-- A subtle guide at Black's standard Python line length.
vim.api.nvim_create_autocmd("FileType", {
  group = aug("python_width"),
  pattern = "python",
  callback = function()
    vim.opt_local.colorcolumn = "88"
  end,
})

-- q closes utility windows
vim.api.nvim_create_autocmd("FileType", {
  group = aug("close_q"),
  pattern = { "help", "qf", "checkhealth", "man" },
  callback = function(ev)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
  end,
})
