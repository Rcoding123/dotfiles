-- colors/fourcolor.lua
-- Minimal dark theme. Deep black background.
-- Syntax uses red / green / blue / white, with Jupyter teal comments.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.g.colors_name = "fourcolor"

local defaults = {
  bg     = "#000000", -- deep black
  fg     = "#FFFFFF", -- white: default text
  red    = "#FF4B4B", -- functions, errors
  green  = "#3FCF6A", -- strings, numbers, constants
  blue   = "#4D9DFF", -- keywords, types
  white  = "#FFFFFF",
  comment = "#408080", -- Jupyter/Pygments comment teal
  gray   = "#6B6B6B", -- UI chrome
  gray_d = "#2A2A2A", -- cursorline, subtle fills
  gray_m = "#3D3D3D", -- borders, whitespace dots
  none   = "NONE",
}
local c = vim.tbl_extend("force", defaults, vim.g.fourcolor_palette or {})

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor UI ──────────────────────────────────────────────────────
hl("Normal",       { fg = c.fg, bg = c.bg })
hl("NormalNC",     { fg = c.fg, bg = c.bg })
hl("NormalFloat",  { fg = c.fg, bg = c.bg })
hl("FloatBorder",  { fg = c.gray_m, bg = c.bg })
hl("FloatTitle",   { fg = c.blue, bg = c.bg, bold = true })
hl("WinSeparator", { fg = c.gray_m, bg = c.bg })
hl("Cursor",       { fg = c.bg, bg = c.fg })
hl("CursorLine",   { bg = c.gray_d })
hl("CursorColumn", { bg = c.gray_d })
hl("ColorColumn",  { bg = c.gray_d })
hl("LineNr",       { fg = c.gray })
hl("CursorLineNr", { fg = c.white, bold = true })
hl("SignColumn",   { bg = c.bg })
hl("Folded",       { fg = c.gray, bg = c.gray_d })
hl("FoldColumn",   { fg = c.gray, bg = c.bg })
hl("EndOfBuffer",  { fg = c.gray_m })
hl("NonText",      { fg = c.gray_m })
hl("Whitespace",   { fg = c.gray_m })
hl("SpecialKey",   { fg = c.gray_m })
hl("Conceal",      { fg = c.gray })
hl("Directory",    { fg = c.blue })
hl("Title",        { fg = c.blue, bold = true })

-- Selection / search
hl("Visual",       { bg = c.gray_m })
hl("VisualNOS",    { bg = c.gray_m })
hl("Search",       { fg = c.bg, bg = c.green })
hl("CurSearch",    { fg = c.bg, bg = c.red })
hl("IncSearch",    { fg = c.bg, bg = c.red })
hl("MatchParen",   { fg = c.red, bold = true, bg = c.gray_d })
hl("QuickFixLine", { bg = c.gray_d })

-- Statusline / tabline
hl("StatusLine",   { fg = c.fg, bg = c.gray_d })
hl("StatusLineNC", { fg = c.gray, bg = c.gray_d })
hl("TabLine",      { fg = c.gray, bg = c.gray_d })
hl("TabLineSel",   { fg = c.white, bg = c.bg, bold = true })
hl("TabLineFill",  { bg = c.gray_d })
hl("WinBar",       { fg = c.fg, bg = c.bg, bold = true })
hl("WinBarNC",     { fg = c.gray, bg = c.bg })

-- Popup menu
hl("Pmenu",        { fg = c.fg, bg = c.gray_d })
hl("PmenuSel",     { fg = c.bg, bg = c.blue, bold = true })
hl("PmenuSbar",    { bg = c.gray_m })
hl("PmenuThumb",   { bg = c.gray })

-- Messages
hl("ErrorMsg",     { fg = c.red, bold = true })
hl("WarningMsg",   { fg = c.red })
hl("MoreMsg",      { fg = c.green })
hl("ModeMsg",      { fg = c.fg, bold = true })
hl("Question",     { fg = c.green })

-- Diffs
hl("DiffAdd",      { fg = c.green, bg = c.gray_d })
hl("DiffChange",   { bg = c.gray_d })
hl("DiffDelete",   { fg = c.red, bg = c.gray_d })
hl("DiffText",     { fg = c.blue, bg = c.gray_m })
hl("Added",        { fg = c.green })
hl("Changed",      { fg = c.blue })
hl("Removed",      { fg = c.red })

-- Spell
hl("SpellBad",     { undercurl = true, sp = c.red })
hl("SpellCap",     { undercurl = true, sp = c.blue })
hl("SpellLocal",   { undercurl = true, sp = c.green })
hl("SpellRare",    { undercurl = true, sp = c.green })

-- ── Syntax (legacy groups) ─────────────────────────────────────────
hl("Comment",      { fg = c.comment, italic = true })

hl("Constant",     { fg = c.green })
hl("String",       { fg = c.green })
hl("Character",    { fg = c.green })
hl("Number",       { fg = c.green })
hl("Float",        { fg = c.green })
hl("Boolean",      { fg = c.green })

hl("Identifier",   { fg = c.white })
hl("Function",     { fg = c.red })

hl("Statement",    { fg = c.blue })
hl("Conditional",  { fg = c.blue })
hl("Repeat",       { fg = c.blue })
hl("Label",        { fg = c.blue })
hl("Operator",     { fg = c.white })
hl("Keyword",      { fg = c.blue })
hl("Exception",    { fg = c.blue })

hl("PreProc",      { fg = c.red })
hl("Include",      { fg = c.red })
hl("Define",       { fg = c.red })
hl("Macro",        { fg = c.red })
hl("PreCondit",    { fg = c.red })

hl("Type",         { fg = c.blue })
hl("StorageClass", { fg = c.blue })
hl("Structure",    { fg = c.blue })
hl("Typedef",      { fg = c.blue })

hl("Special",      { fg = c.red })
hl("SpecialChar",  { fg = c.green })
hl("Tag",          { fg = c.white })
hl("Delimiter",    { fg = c.white })
hl("SpecialComment",{ fg = c.comment, bold = true })
hl("Debug",        { fg = c.red })
hl("Underlined",   { fg = c.blue, underline = true })
hl("Error",        { fg = c.red, bold = true })
hl("Todo",         { fg = c.bg, bg = c.blue, bold = true })

-- ── Treesitter ─────────────────────────────────────────────────────
hl("@comment",              { link = "Comment" })
hl("@comment.todo",         { link = "Todo" })
hl("@comment.error",        { fg = c.red, bold = true })
hl("@comment.warning",      { fg = c.red })
hl("@comment.note",         { fg = c.blue })

hl("@string",               { link = "String" })
hl("@string.escape",        { fg = c.green })
hl("@string.regexp",        { fg = c.green })
hl("@character",            { link = "Character" })
hl("@number",               { link = "Number" })
hl("@number.float",         { link = "Float" })
hl("@boolean",              { link = "Boolean" })

hl("@constant",             { fg = c.green })
hl("@constant.builtin",     { fg = c.green })
hl("@constant.macro",       { fg = c.red })

hl("@variable",             { fg = c.white })
hl("@variable.builtin",     { fg = c.white })
hl("@variable.parameter",   { fg = c.white })
hl("@variable.member",      { fg = c.white })
hl("@property",             { fg = c.white })
hl("@field",                { fg = c.white })

hl("@function",             { fg = c.red })
hl("@function.builtin",     { fg = c.red })
hl("@function.call",        { fg = c.red })
hl("@function.macro",       { fg = c.red })
hl("@method",               { fg = c.red })
hl("@method.call",          { fg = c.red })
hl("@constructor",          { fg = c.red })

hl("@keyword",              { link = "Keyword" })
hl("@keyword.function",     { fg = c.blue })
hl("@keyword.operator",     { fg = c.blue })
hl("@keyword.return",       { fg = c.blue })
hl("@keyword.import",       { fg = c.red })
hl("@keyword.directive",    { fg = c.red })
hl("@keyword.directive.define", { fg = c.red })
hl("@keyword.conditional",  { fg = c.blue })
hl("@keyword.repeat",       { fg = c.blue })
hl("@keyword.exception",    { fg = c.blue })
hl("@keyword.modifier",     { fg = c.blue })
hl("@keyword.type",         { fg = c.blue })

hl("@operator",             { fg = c.white })
hl("@punctuation.delimiter",{ fg = c.white })
hl("@punctuation.bracket",  { fg = c.white })
hl("@punctuation.special",  { fg = c.red })

hl("@type",                 { fg = c.blue })
hl("@type.builtin",         { fg = c.blue })
hl("@type.definition",      { fg = c.blue })
hl("@attribute",            { fg = c.red })
hl("@namespace",            { fg = c.white })
hl("@module",               { fg = c.white })
hl("@label",                { fg = c.blue })

-- markup (markdown, etc.)
hl("@markup.heading",       { fg = c.blue, bold = true })
hl("@markup.strong",        { fg = c.white, bold = true })
hl("@markup.italic",        { fg = c.white, italic = true })
hl("@markup.link",          { fg = c.green, underline = true })
hl("@markup.link.url",      { fg = c.green, underline = true })
hl("@markup.raw",           { fg = c.green })
hl("@markup.list",          { fg = c.blue })
hl("@diff.plus",            { fg = c.green })
hl("@diff.minus",           { fg = c.red })
hl("@diff.delta",           { fg = c.blue })

-- ── LSP semantic tokens ────────────────────────────────────────────
hl("@lsp.type.class",         { link = "@type" })
hl("@lsp.type.struct",        { link = "@type" })
hl("@lsp.type.enum",          { link = "@type" })
hl("@lsp.type.enumMember",    { link = "@constant" })
hl("@lsp.type.type",          { link = "@type" })
hl("@lsp.type.typeParameter", { link = "@type" })
hl("@lsp.type.namespace",     { link = "@namespace" })
hl("@lsp.type.function",      { link = "@function" })
hl("@lsp.type.method",        { link = "@method" })
hl("@lsp.type.macro",         { link = "@function.macro" })
hl("@lsp.type.parameter",     { link = "@variable.parameter" })
hl("@lsp.type.variable",      { link = "@variable" })
hl("@lsp.type.property",      { link = "@property" })
hl("@lsp.type.keyword",       { link = "Keyword" })
hl("@lsp.mod.deprecated",     { strikethrough = true })

hl("LspReferenceText",  { bg = c.gray_d })
hl("LspReferenceRead",  { bg = c.gray_d })
hl("LspReferenceWrite", { bg = c.gray_d, bold = true })
hl("LspSignatureActiveParameter", { fg = c.bg, bg = c.blue, bold = true })
hl("LspInlayHint",      { fg = c.gray, bg = c.bg })

-- ── Diagnostics ────────────────────────────────────────────────────
hl("DiagnosticError", { fg = c.red })
hl("DiagnosticWarn",  { fg = c.blue })
hl("DiagnosticInfo",  { fg = c.white })
hl("DiagnosticHint",  { fg = c.green })
hl("DiagnosticOk",    { fg = c.green })
hl("DiagnosticVirtualTextError", { fg = c.red })
hl("DiagnosticVirtualTextWarn",  { fg = c.blue })
hl("DiagnosticVirtualTextInfo",  { fg = c.gray })
hl("DiagnosticVirtualTextHint",  { fg = c.green })
hl("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hl("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.blue })
hl("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.white })
hl("DiagnosticUnderlineHint",  { undercurl = true, sp = c.green })
hl("DiagnosticUnnecessary",    { fg = c.gray, undercurl = true, sp = c.gray })

-- ── Plugins (kept minimal, same 4 colors) ──────────────────────────
-- gitsigns
hl("GitSignsAdd",    { fg = c.green, bg = c.bg })
hl("GitSignsChange", { fg = c.blue, bg = c.bg })
hl("GitSignsDelete", { fg = c.red, bg = c.bg })
hl("GitSignsCurrentLineBlame", { fg = c.gray })

-- telescope
hl("TelescopeNormal",        { fg = c.fg, bg = c.bg })
hl("TelescopeBorder",        { fg = c.gray_m, bg = c.bg })
hl("TelescopePromptNormal",  { fg = c.fg, bg = c.bg })
hl("TelescopePromptBorder",  { fg = c.gray_m, bg = c.bg })
hl("TelescopePromptPrefix",  { fg = c.red })
hl("TelescopeTitle",         { fg = c.blue, bold = true })
hl("TelescopeSelection",     { bg = c.gray_d })
hl("TelescopeSelectionCaret",{ fg = c.red, bg = c.gray_d })
hl("TelescopeMatching",      { fg = c.red, bold = true })

-- nvim-cmp
hl("CmpItemAbbr",           { fg = c.fg })
hl("CmpItemAbbrDeprecated", { fg = c.gray, strikethrough = true })
hl("CmpItemAbbrMatch",      { fg = c.blue, bold = true })
hl("CmpItemAbbrMatchFuzzy", { fg = c.blue })
hl("CmpItemKind",           { fg = c.gray })
hl("CmpItemMenu",           { fg = c.gray })
hl("CmpGhostText",          { fg = c.gray })

-- which-key
hl("WhichKey",          { fg = c.red })
hl("WhichKeyGroup",     { fg = c.blue })
hl("WhichKeyDesc",      { fg = c.fg })
hl("WhichKeySeparator", { fg = c.gray })
hl("WhichKeyFloat",     { bg = c.bg })

-- indent-blankline
hl("IblIndent",     { fg = c.gray_m })
hl("IblWhitespace", { fg = c.gray_m })
hl("IblScope",      { fg = c.gray })

-- oil
hl("OilDir",     { fg = c.blue, bold = true })
hl("OilDirIcon", { fg = c.blue })
hl("OilLink",    { fg = c.green })
hl("OilFile",    { fg = c.white })

-- trouble
hl("TroubleNormal",   { fg = c.fg, bg = c.bg })
hl("TroubleNormalNC", { fg = c.fg, bg = c.bg })

-- lazy / mason UI
hl("LazyNormal", { fg = c.fg, bg = c.bg })
hl("MasonNormal", { fg = c.fg, bg = c.bg })
