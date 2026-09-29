-- colors/ghostwire.lua
-- Ghostwire: a blue-black terminal operations desk.
--
-- The quiet areas are deliberately almost black.  Code is lit like a wiretap:
-- cyan for control flow, green for payloads, magenta for calls, and amber for
-- data worth watching.  It stays readable for long Python and C++ sessions.

vim.g.fourcolor_palette = {
  bg = "#030712",
  fg = "#D6E6F0",
  red = "#FF5FA3",
  green = "#7CFFB2",
  blue = "#43D9FF",
  white = "#D6E6F0",
  comment = "#4E6A7D",
  gray = "#7894A6",
  gray_d = "#07121E",
  gray_m = "#183247",
}

-- Fourcolor provides a complete, small-plugin baseline.  Ghostwire then gives
-- each semantic role its own signal color without turning the editor neon soup.
vim.cmd.colorscheme("fourcolor")
vim.g.fourcolor_palette = nil
vim.g.colors_name = "ghostwire"

local p = {
  void = "#030712",
  panel = "#07121E",
  panel_hi = "#0D2030",
  selection = "#12364D",
  fg = "#D6E6F0",
  muted = "#4E6A7D",
  comment = "#7CB6C7",
  steel = "#7894A6",
  cyan = "#43D9FF",
  blue = "#69A7FF",
  green = "#7CFFB2",
  magenta = "#FF5FA3",
  amber = "#FFC857",
  red = "#FF6B6B",
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor frame: no large light boxes.  The current line is a faint scan band.
hl("Normal", { fg = p.fg, bg = p.void })
hl("NormalNC", { fg = p.fg, bg = p.void })
hl("NormalFloat", { fg = p.fg, bg = p.panel })
hl("FloatBorder", { fg = p.cyan, bg = p.panel })
hl("FloatTitle", { fg = p.cyan, bg = p.panel, bold = true })
hl("WinSeparator", { fg = p.panel_hi, bg = p.void })
hl("Cursor", { fg = p.void, bg = p.green })
hl("CursorLine", { bg = p.panel })
hl("CursorColumn", { bg = p.panel })
hl("ColorColumn", { bg = p.panel })
hl("LineNr", { fg = p.muted, bg = p.void })
hl("CursorLineNr", { fg = p.cyan, bg = p.panel, bold = true })
hl("SignColumn", { bg = p.void })
hl("Folded", { fg = p.steel, bg = p.panel })
hl("FoldColumn", { fg = p.muted, bg = p.void })
hl("EndOfBuffer", { fg = p.void, bg = p.void })
hl("NonText", { fg = p.panel_hi })
hl("Whitespace", { fg = p.panel_hi })
hl("SpecialKey", { fg = p.panel_hi })
hl("Conceal", { fg = p.muted })
hl("Directory", { fg = p.cyan, bold = true })
hl("Title", { fg = p.cyan, bold = true })

-- Selection and search act like an instrument panel, not a highlighter pen.
hl("Visual", { fg = p.fg, bg = p.selection })
hl("VisualNOS", { fg = p.fg, bg = p.selection })
hl("Search", { fg = p.void, bg = p.amber, bold = true })
hl("CurSearch", { fg = p.void, bg = p.magenta, bold = true })
hl("IncSearch", { fg = p.void, bg = p.magenta, bold = true })
hl("MatchParen", { fg = p.void, bg = p.cyan, bold = true })
hl("QuickFixLine", { bg = p.panel_hi })

hl("StatusLine", { fg = p.fg, bg = p.panel })
hl("StatusLineNC", { fg = p.muted, bg = p.panel })
hl("TabLine", { fg = p.muted, bg = p.panel })
hl("TabLineSel", { fg = p.cyan, bg = p.void, bold = true })
hl("TabLineFill", { bg = p.panel })
hl("WinBar", { fg = p.steel, bg = p.void, bold = true })
hl("WinBarNC", { fg = p.muted, bg = p.void })

hl("Pmenu", { fg = p.fg, bg = p.panel })
hl("PmenuSel", { fg = p.void, bg = p.cyan, bold = true })
hl("PmenuSbar", { bg = p.panel_hi })
hl("PmenuThumb", { bg = p.steel })

-- Syntax: categories are memorable, with high contrast on the void background.
hl("Comment", { fg = p.comment, italic = true })
hl("Constant", { fg = p.amber })
hl("String", { fg = p.green })
hl("Character", { fg = p.green })
hl("Number", { fg = p.amber })
hl("Float", { fg = p.amber })
hl("Boolean", { fg = p.amber, bold = true })
hl("Identifier", { fg = p.fg })
hl("Function", { fg = p.magenta })
hl("Statement", { fg = p.cyan })
hl("Conditional", { fg = p.cyan })
hl("Repeat", { fg = p.cyan })
hl("Label", { fg = p.cyan })
hl("Operator", { fg = p.steel })
hl("Keyword", { fg = p.cyan })
hl("Exception", { fg = p.cyan })
hl("PreProc", { fg = p.amber })
hl("Include", { fg = p.amber })
hl("Define", { fg = p.amber })
hl("Macro", { fg = p.amber })
hl("PreCondit", { fg = p.amber })
hl("Type", { fg = p.blue })
hl("StorageClass", { fg = p.cyan })
hl("Structure", { fg = p.blue })
hl("Typedef", { fg = p.blue })
hl("Special", { fg = p.magenta })
hl("SpecialChar", { fg = p.magenta })
hl("Tag", { fg = p.blue })
hl("Delimiter", { fg = p.steel })
hl("SpecialComment", { fg = p.comment, bold = true })
hl("Underlined", { fg = p.cyan, underline = true })
hl("Error", { fg = p.red, bold = true })
hl("Todo", { fg = p.void, bg = p.amber, bold = true })

-- Tree-sitter and LSP semantic tokens are explicit so Python and C++ agree.
hl("@comment", { link = "Comment" })
hl("@comment.todo", { link = "Todo" })
hl("@comment.error", { fg = p.red, bold = true })
hl("@comment.warning", { fg = p.amber, bold = true })
hl("@comment.note", { fg = p.cyan, bold = true })
hl("@string", { link = "String" })
hl("@string.escape", { fg = p.magenta })
hl("@string.regexp", { fg = p.green })
hl("@character", { link = "Character" })
hl("@number", { link = "Number" })
hl("@number.float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = p.amber })
hl("@constant.builtin", { fg = p.amber, bold = true })
hl("@constant.macro", { fg = p.amber })
hl("@variable", { fg = p.fg })
hl("@variable.builtin", { fg = p.blue })
hl("@variable.parameter", { fg = p.fg })
hl("@variable.member", { fg = p.fg })
hl("@property", { fg = p.fg })
hl("@field", { fg = p.fg })
hl("@function", { fg = p.magenta })
hl("@function.builtin", { fg = p.magenta })
hl("@function.call", { fg = p.magenta })
hl("@function.macro", { fg = p.amber })
hl("@method", { fg = p.magenta })
hl("@method.call", { fg = p.magenta })
hl("@constructor", { fg = p.magenta })
hl("@keyword", { fg = p.cyan })
hl("@keyword.function", { fg = p.cyan })
hl("@keyword.operator", { fg = p.cyan })
hl("@keyword.return", { fg = p.cyan })
hl("@keyword.import", { fg = p.amber })
hl("@keyword.directive", { fg = p.amber })
hl("@keyword.directive.define", { fg = p.amber })
hl("@keyword.conditional", { fg = p.cyan })
hl("@keyword.repeat", { fg = p.cyan })
hl("@keyword.exception", { fg = p.cyan })
hl("@keyword.modifier", { fg = p.cyan })
hl("@keyword.type", { fg = p.blue })
hl("@operator", { fg = p.steel })
hl("@punctuation.delimiter", { fg = p.steel })
hl("@punctuation.bracket", { fg = p.steel })
hl("@punctuation.special", { fg = p.magenta })
hl("@type", { fg = p.blue })
hl("@type.builtin", { fg = p.blue, bold = true })
hl("@type.definition", { fg = p.blue })
hl("@attribute", { fg = p.magenta })
hl("@namespace", { fg = p.blue })
hl("@module", { fg = p.blue })
hl("@label", { fg = p.cyan })
hl("@tag", { fg = p.blue })
hl("@tag.attribute", { fg = p.amber })
hl("@tag.delimiter", { fg = p.steel })
hl("@markup.heading", { fg = p.cyan, bold = true })
hl("@markup.strong", { fg = p.fg, bold = true })
hl("@markup.italic", { fg = p.fg, italic = true })
hl("@markup.link", { fg = p.green, underline = true })
hl("@markup.link.url", { fg = p.green, underline = true })
hl("@markup.raw", { fg = p.green })
hl("@markup.list", { fg = p.cyan })
hl("@diff.plus", { fg = p.green })
hl("@diff.minus", { fg = p.red })
hl("@diff.delta", { fg = p.amber })
hl("@lsp.type.class", { link = "@type" })
hl("@lsp.type.struct", { link = "@type" })
hl("@lsp.type.enum", { link = "@type" })
hl("@lsp.type.enumMember", { link = "@constant" })
hl("@lsp.type.type", { link = "@type" })
hl("@lsp.type.typeParameter", { link = "@type" })
hl("@lsp.type.namespace", { link = "@namespace" })
hl("@lsp.type.function", { link = "@function" })
hl("@lsp.type.method", { link = "@method" })
hl("@lsp.type.macro", { link = "@function.macro" })
hl("@lsp.type.parameter", { link = "@variable.parameter" })
hl("@lsp.type.variable", { link = "@variable" })
hl("@lsp.type.property", { link = "@property" })
hl("@lsp.type.keyword", { link = "Keyword" })
hl("@lsp.mod.deprecated", { strikethrough = true })

-- Diagnostics read like a compact traffic system; they never paint the whole line.
hl("DiagnosticError", { fg = p.red })
hl("DiagnosticWarn", { fg = p.amber })
hl("DiagnosticInfo", { fg = p.cyan })
hl("DiagnosticHint", { fg = p.green })
hl("DiagnosticOk", { fg = p.green })
hl("DiagnosticVirtualTextError", { fg = p.red })
hl("DiagnosticVirtualTextWarn", { fg = p.amber })
hl("DiagnosticVirtualTextInfo", { fg = p.cyan })
hl("DiagnosticVirtualTextHint", { fg = p.green })
hl("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.amber })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.cyan })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.green })
hl("DiagnosticUnnecessary", { fg = p.muted, undercurl = true, sp = p.muted })

hl("LspReferenceText", { bg = p.panel_hi })
hl("LspReferenceRead", { bg = p.panel_hi })
hl("LspReferenceWrite", { bg = p.panel_hi, bold = true })
hl("LspSignatureActiveParameter", { fg = p.void, bg = p.cyan, bold = true })
hl("LspInlayHint", { fg = p.muted, bg = p.panel })

-- Plugin surfaces.
hl("GitSignsAdd", { fg = p.green, bg = p.void })
hl("GitSignsChange", { fg = p.amber, bg = p.void })
hl("GitSignsDelete", { fg = p.red, bg = p.void })
hl("GitSignsCurrentLineBlame", { fg = p.muted })
hl("TelescopeNormal", { fg = p.fg, bg = p.panel })
hl("TelescopeBorder", { fg = p.cyan, bg = p.panel })
hl("TelescopePromptNormal", { fg = p.fg, bg = p.panel })
hl("TelescopePromptBorder", { fg = p.cyan, bg = p.panel })
hl("TelescopePromptPrefix", { fg = p.magenta })
hl("TelescopeTitle", { fg = p.cyan, bg = p.panel, bold = true })
hl("TelescopeSelection", { fg = p.fg, bg = p.panel_hi })
hl("TelescopeSelectionCaret", { fg = p.magenta, bg = p.panel_hi, bold = true })
hl("TelescopeMatching", { fg = p.cyan, bold = true })
hl("CmpItemAbbr", { fg = p.fg })
hl("CmpItemAbbrDeprecated", { fg = p.muted, strikethrough = true })
hl("CmpItemAbbrMatch", { fg = p.cyan, bold = true })
hl("CmpItemAbbrMatchFuzzy", { fg = p.cyan })
hl("CmpItemKind", { fg = p.magenta })
hl("CmpItemMenu", { fg = p.muted })
hl("CmpGhostText", { fg = p.muted })
hl("WhichKey", { fg = p.cyan })
hl("WhichKeyGroup", { fg = p.magenta })
hl("WhichKeyDesc", { fg = p.fg })
hl("WhichKeySeparator", { fg = p.muted })
hl("WhichKeyFloat", { bg = p.panel })
hl("IblIndent", { fg = p.panel_hi })
hl("IblWhitespace", { fg = p.panel_hi })
hl("IblScope", { fg = p.cyan })
hl("OilDir", { fg = p.cyan, bold = true })
hl("OilDirIcon", { fg = p.cyan })
hl("OilLink", { fg = p.green })
hl("OilFile", { fg = p.fg })
hl("TroubleNormal", { fg = p.fg, bg = p.panel })
hl("TroubleNormalNC", { fg = p.fg, bg = p.panel })
hl("LazyNormal", { fg = p.fg, bg = p.panel })
hl("MasonNormal", { fg = p.fg, bg = p.panel })

-- Neovim's embedded terminal inherits the same instruments-on-black palette.
vim.g.terminal_color_0 = p.void
vim.g.terminal_color_1 = p.red
vim.g.terminal_color_2 = p.green
vim.g.terminal_color_3 = p.amber
vim.g.terminal_color_4 = p.blue
vim.g.terminal_color_5 = p.magenta
vim.g.terminal_color_6 = p.cyan
vim.g.terminal_color_7 = p.fg
vim.g.terminal_color_8 = p.muted
vim.g.terminal_color_9 = p.red
vim.g.terminal_color_10 = p.green
vim.g.terminal_color_11 = p.amber
vim.g.terminal_color_12 = p.blue
vim.g.terminal_color_13 = p.magenta
vim.g.terminal_color_14 = p.cyan
vim.g.terminal_color_15 = "#FFFFFF"
