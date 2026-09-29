-- colors/quietlab.lua
-- Calm, high-contrast editing palette built on the local fourcolor theme.

vim.g.fourcolor_palette = {
  bg = "#0B0F14",
  fg = "#D8DEE9",
  red = "#FF7A90",
  green = "#98C379",
  blue = "#7AA2F7",
  white = "#D8DEE9",
  comment = "#408080",
  gray = "#7F8C98",
  gray_d = "#151B23",
  gray_m = "#26354A",
}

vim.cmd.colorscheme("fourcolor")
vim.g.fourcolor_palette = nil
vim.g.colors_name = "quietlab"

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local c = {
  bg = "#0B0F14",
  fg = "#D8DEE9",
  selection = "#26354A",
  keyword = "#7AA2F7",
  func = "#FF7A90",
  string = "#98C379",
  number = "#E5C07B",
  type = "#C678DD",
  error = "#FF5F5F",
  warning = "#E5C07B",
  info = "#56B6C2",
  hint = "#7F8C98",
}

-- Give semantic categories distinct colors without making the screen noisy.
hl("Visual", { bg = c.selection })
hl("VisualNOS", { bg = c.selection })
hl("Number", { fg = c.number })
hl("Float", { fg = c.number })
hl("Boolean", { fg = c.number })
hl("Constant", { fg = c.number })
hl("Type", { fg = c.type })
hl("Typedef", { fg = c.type })
hl("Structure", { fg = c.type })
hl("Function", { fg = c.func })
hl("String", { fg = c.string })
hl("Keyword", { fg = c.keyword })

hl("DiagnosticError", { fg = c.error })
hl("DiagnosticWarn", { fg = c.warning })
hl("DiagnosticInfo", { fg = c.info })
hl("DiagnosticHint", { fg = c.hint })
hl("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.warning })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.info })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.hint })

hl("Normal", { fg = c.fg, bg = c.bg })
hl("NormalFloat", { fg = c.fg, bg = c.bg })
