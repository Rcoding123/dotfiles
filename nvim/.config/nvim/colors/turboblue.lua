-- colors/turboblue.lua
-- Borland Turbo C++ 3.0 IDE, resurrected.
-- Strict DOS EGA 16-color palette. Blue editor, yellow code, white keywords,
-- cyan strings, gray comments, green preprocessor. Gray Turbo Vision menus.
-- No italics anywhere -- DOS didn't have them.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.g.colors_name = "turboblue"

-- ── DOS EGA palette ────────────────────────────────────────────────
local p = {
  black    = "#000000",
  blue     = "#0000AA", -- THE background
  green    = "#00AA00",
  cyan     = "#00AAAA",
  red      = "#AA0000",
  magenta  = "#AA00AA",
  brown    = "#AA5500",
  lgray    = "#AAAAAA", -- menus, comments
  dgray    = "#555555",
  lblue    = "#5555FF",
  lgreen   = "#55FF55", -- preprocessor
  lcyan    = "#55FFFF", -- strings, numbers
  lred     = "#FF5555",
  lmagenta = "#FF55FF",
  yellow   = "#FFFF55", -- identifiers / plain code
  white    = "#FFFFFF", -- reserved words
  -- utility shades (not EGA -- needed for cursorline/guides on solid blue)
  blue_hi  = "#1414B8", -- cursorline
  blue_dim = "#3737C8", -- indent guides, whitespace chars
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor UI ──────────────────────────────────────────────────────
hl("Normal",        { fg = p.yellow, bg = p.blue })
hl("NormalNC",      { fg = p.yellow, bg = p.blue })
hl("NormalFloat",   { fg = p.yellow, bg = p.blue })
hl("FloatBorder",   { fg = p.white, bg = p.blue })   -- double-line white frames
hl("FloatTitle",    { fg = p.white, bg = p.blue, bold = true })
hl("WinSeparator",  { fg = p.white, bg = p.blue })
hl("Cursor",        { fg = p.blue, bg = p.yellow })
hl("CursorLine",    { bg = p.blue_hi })
hl("CursorColumn",  { bg = p.blue_hi })
hl("ColorColumn",   { bg = p.blue_hi })
hl("LineNr",        { fg = p.lblue, bg = p.blue })
hl("CursorLineNr",  { fg = p.yellow, bg = p.blue_hi, bold = true })
hl("SignColumn",    { bg = p.blue })
hl("Folded",        { fg = p.lcyan, bg = p.blue_hi })
hl("FoldColumn",    { fg = p.lblue, bg = p.blue })
hl("EndOfBuffer",   { fg = p.lblue, bg = p.blue })
hl("NonText",       { fg = p.blue_dim })
hl("Whitespace",    { fg = p.blue_dim })
hl("SpecialKey",    { fg = p.blue_dim })
hl("Conceal",       { fg = p.lgray })

-- Selection / search: DOS inverse-video style
hl("Visual",        { fg = p.black, bg = p.cyan })
hl("VisualNOS",     { fg = p.black, bg = p.cyan })
hl("Search",        { fg = p.black, bg = p.cyan })
hl("CurSearch",     { fg = p.blue, bg = p.yellow, bold = true })
hl("IncSearch",     { fg = p.blue, bg = p.white, bold = true })
hl("MatchParen",    { fg = p.blue, bg = p.white, bold = true })
hl("QuickFixLine",  { fg = p.black, bg = p.cyan })

-- Statusline / tabline: the gray Turbo menu bar
hl("StatusLine",    { fg = p.black, bg = p.lgray })
hl("StatusLineNC",  { fg = p.dgray, bg = p.lgray })
hl("TabLine",       { fg = p.black, bg = p.lgray })
hl("TabLineSel",    { fg = p.white, bg = p.blue, bold = true })
hl("TabLineFill",   { bg = p.lgray })
hl("WinBar",        { fg = p.yellow, bg = p.blue, bold = true })
hl("WinBarNC",      { fg = p.lgray, bg = p.blue })

-- Popup menu (completion): gray Turbo dropdown, red match letters
hl("Pmenu",         { fg = p.black, bg = p.lgray })
hl("PmenuSel",      { fg = p.black, bg = p.cyan, bold = true })
hl("PmenuSbar",     { bg = p.dgray })
hl("PmenuThumb",    { bg = p.white })

-- Messages
hl("ErrorMsg",      { fg = p.white, bg = p.red, bold = true })
hl("WarningMsg",    { fg = p.yellow, bold = true })
hl("MoreMsg",       { fg = p.lgreen })
hl("ModeMsg",       { fg = p.yellow, bold = true })
hl("Question",      { fg = p.lgreen })
hl("Title",         { fg = p.white, bold = true })
hl("Directory",     { fg = p.white, bold = true })

-- Diffs
hl("DiffAdd",       { fg = p.white, bg = p.green })
hl("DiffChange",    { bg = p.blue_hi })
hl("DiffDelete",    { fg = p.white, bg = p.red })
hl("DiffText",      { fg = p.black, bg = p.cyan })
hl("Added",         { fg = p.lgreen })
hl("Changed",       { fg = p.yellow })
hl("Removed",       { fg = p.lred })

-- Spell
hl("SpellBad",      { undercurl = true, sp = p.lred })
hl("SpellCap",      { undercurl = true, sp = p.yellow })
hl("SpellLocal",    { undercurl = true, sp = p.lcyan })
hl("SpellRare",     { undercurl = true, sp = p.lmagenta })

-- ── Syntax: the actual Turbo C++ editor colors ─────────────────────
hl("Comment",       { fg = p.lgray })                 -- light gray, NOT italic
hl("Constant",      { fg = p.yellow })
hl("String",        { fg = p.lcyan })
hl("Character",     { fg = p.lcyan })
hl("Number",        { fg = p.lcyan })
hl("Float",         { fg = p.lcyan })
hl("Boolean",       { fg = p.white, bold = true })    -- true/false are reserved words
hl("Identifier",    { fg = p.yellow })
hl("Function",      { fg = p.yellow })
hl("Statement",     { fg = p.white, bold = true })    -- reserved words: bold white
hl("Conditional",   { fg = p.white, bold = true })
hl("Repeat",        { fg = p.white, bold = true })
hl("Label",         { fg = p.white, bold = true })
hl("Operator",      { fg = p.yellow })                -- symbols were yellow
hl("Keyword",       { fg = p.white, bold = true })
hl("Exception",     { fg = p.white, bold = true })
hl("PreProc",       { fg = p.lgreen })                -- preprocessor: light green
hl("Include",       { fg = p.lgreen })
hl("Define",        { fg = p.lgreen })
hl("Macro",         { fg = p.lgreen })
hl("PreCondit",     { fg = p.lgreen })
hl("Type",          { fg = p.white })                 -- types: white, not bold
hl("StorageClass",  { fg = p.white, bold = true })
hl("Structure",     { fg = p.white, bold = true })
hl("Typedef",       { fg = p.white, bold = true })
hl("Special",       { fg = p.lcyan })
hl("SpecialChar",   { fg = p.lmagenta })              -- \n \t escapes
hl("Tag",           { fg = p.yellow })
hl("Delimiter",     { fg = p.yellow })
hl("SpecialComment",{ fg = p.white })
hl("Debug",         { fg = p.lred })
hl("Underlined",    { fg = p.lcyan, underline = true })
hl("Error",         { fg = p.white, bg = p.red })
hl("Todo",          { fg = p.black, bg = p.yellow, bold = true })

-- ── Treesitter ─────────────────────────────────────────────────────
hl("@comment",              { link = "Comment" })
hl("@comment.todo",         { link = "Todo" })
hl("@comment.error",        { fg = p.white, bg = p.red, bold = true })
hl("@comment.warning",      { fg = p.black, bg = p.yellow, bold = true })
hl("@comment.note",         { fg = p.black, bg = p.lcyan, bold = true })
hl("@string",               { link = "String" })
hl("@string.escape",        { fg = p.lmagenta })
hl("@string.regexp",        { fg = p.lcyan })
hl("@character",            { link = "Character" })
hl("@number",               { link = "Number" })
hl("@number.float",         { link = "Float" })
hl("@boolean",              { link = "Boolean" })
hl("@constant",             { fg = p.yellow })
hl("@constant.builtin",     { fg = p.white, bold = true })  -- NULL, nullptr
hl("@constant.macro",       { fg = p.lgreen })              -- #define'd constants
hl("@variable",             { fg = p.yellow })
hl("@variable.builtin",     { fg = p.white })               -- this
hl("@variable.parameter",   { fg = p.yellow })
hl("@variable.member",      { fg = p.yellow })              -- struct members
hl("@property",             { fg = p.yellow })
hl("@field",                { fg = p.yellow })
hl("@function",             { fg = p.yellow })
hl("@function.builtin",     { fg = p.yellow })
hl("@function.call",        { fg = p.yellow })
hl("@function.macro",       { fg = p.lgreen })              -- macro "calls"
hl("@method",               { fg = p.yellow })
hl("@constructor",          { fg = p.yellow })
hl("@keyword",              { link = "Keyword" })
hl("@keyword.function",     { link = "Keyword" })
hl("@keyword.operator",     { link = "Keyword" })           -- new, delete, sizeof
hl("@keyword.return",       { link = "Keyword" })
hl("@keyword.import",       { fg = p.lgreen })              -- #include
hl("@keyword.directive",    { fg = p.lgreen })
hl("@keyword.directive.define", { fg = p.lgreen })
hl("@keyword.conditional",  { link = "Conditional" })
hl("@keyword.repeat",       { link = "Repeat" })
hl("@keyword.exception",    { link = "Exception" })
hl("@keyword.modifier",     { link = "StorageClass" })      -- const, static
hl("@keyword.type",         { link = "Structure" })         -- struct, class, enum
hl("@operator",             { link = "Operator" })
hl("@punctuation.delimiter",{ fg = p.yellow })
hl("@punctuation.bracket",  { fg = p.yellow })
hl("@punctuation.special",  { fg = p.yellow })
hl("@type",                 { fg = p.white })
hl("@type.builtin",         { fg = p.white, bold = true })  -- int, char, void
hl("@type.definition",      { fg = p.white })
hl("@attribute",            { fg = p.lgreen })              -- [[nodiscard]]
hl("@namespace",            { fg = p.yellow })
hl("@module",               { fg = p.yellow })
hl("@label",                { link = "Label" })
hl("@tag",                  { fg = p.white })
hl("@tag.attribute",        { fg = p.yellow })
hl("@tag.delimiter",        { fg = p.yellow })
hl("@markup.heading",       { fg = p.white, bold = true })
hl("@markup.strong",        { fg = p.yellow, bold = true })
hl("@markup.italic",        { fg = p.yellow, underline = true }) -- no italics in DOS
hl("@markup.link",          { fg = p.lcyan, underline = true })
hl("@markup.link.url",      { fg = p.lcyan, underline = true })
hl("@markup.raw",           { fg = p.lcyan })
hl("@markup.list",          { fg = p.white })
hl("@diff.plus",            { fg = p.lgreen })
hl("@diff.minus",           { fg = p.lred })
hl("@diff.delta",           { fg = p.yellow })

-- ── LSP semantic tokens: defer to treesitter/syntax mapping ────────
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
hl("@lsp.type.comment",       { link = "Comment" })
hl("@lsp.type.keyword",       { link = "Keyword" })
hl("@lsp.mod.deprecated",     { strikethrough = true })

-- LSP UI
hl("LspReferenceText",  { bg = p.blue_hi })
hl("LspReferenceRead",  { bg = p.blue_hi })
hl("LspReferenceWrite", { bg = p.blue_hi, bold = true })
hl("LspSignatureActiveParameter", { fg = p.black, bg = p.cyan, bold = true })
hl("LspInlayHint",      { fg = p.lblue, bg = p.blue })

-- ── Diagnostics ────────────────────────────────────────────────────
hl("DiagnosticError", { fg = p.lred })
hl("DiagnosticWarn",  { fg = p.yellow })
hl("DiagnosticInfo",  { fg = p.lcyan })
hl("DiagnosticHint",  { fg = p.lgreen })
hl("DiagnosticOk",    { fg = p.lgreen })
hl("DiagnosticVirtualTextError", { fg = p.lred })
hl("DiagnosticVirtualTextWarn",  { fg = p.yellow })
hl("DiagnosticVirtualTextInfo",  { fg = p.lcyan })
hl("DiagnosticVirtualTextHint",  { fg = p.lgreen })
hl("DiagnosticUnderlineError", { undercurl = true, sp = p.lred })
hl("DiagnosticUnderlineWarn",  { undercurl = true, sp = p.yellow })
hl("DiagnosticUnderlineInfo",  { undercurl = true, sp = p.lcyan })
hl("DiagnosticUnderlineHint",  { undercurl = true, sp = p.lgreen })
hl("DiagnosticUnnecessary",    { fg = p.lgray, undercurl = true, sp = p.lgray })

-- ── Plugins ────────────────────────────────────────────────────────
-- gitsigns
hl("GitSignsAdd",    { fg = p.lgreen, bg = p.blue })
hl("GitSignsChange", { fg = p.yellow, bg = p.blue })
hl("GitSignsDelete", { fg = p.lred, bg = p.blue })
hl("GitSignsCurrentLineBlame", { fg = p.lblue })

-- telescope: blue windows, white double frames, cyan selection bar
hl("TelescopeNormal",        { fg = p.yellow, bg = p.blue })
hl("TelescopeBorder",        { fg = p.white, bg = p.blue })
hl("TelescopePromptNormal",  { fg = p.yellow, bg = p.blue })
hl("TelescopePromptBorder",  { fg = p.white, bg = p.blue })
hl("TelescopePromptPrefix",  { fg = p.yellow, bold = true })
hl("TelescopePromptCounter", { fg = p.lblue })
hl("TelescopeTitle",         { fg = p.white, bg = p.blue, bold = true })
hl("TelescopeSelection",     { fg = p.black, bg = p.cyan })
hl("TelescopeSelectionCaret",{ fg = p.black, bg = p.cyan, bold = true })
hl("TelescopeMatching",      { fg = p.lred, bold = true })  -- red hotkey letters

-- nvim-cmp: gray Turbo dropdown
hl("CmpBorder",             { fg = p.black, bg = p.lgray })
hl("CmpItemAbbr",           { fg = p.black })
hl("CmpItemAbbrDeprecated", { fg = p.dgray, strikethrough = true })
hl("CmpItemAbbrMatch",      { fg = p.red, bold = true })    -- red match letters
hl("CmpItemAbbrMatchFuzzy", { fg = p.red })
hl("CmpItemKind",           { fg = p.dgray })
hl("CmpItemMenu",           { fg = p.dgray })
hl("CmpGhostText",          { fg = p.lblue })

-- which-key: gray Turbo Vision dialog
hl("WhichKeyNormal",    { fg = p.black, bg = p.lgray })
hl("WhichKeyBorder",    { fg = p.black, bg = p.lgray })
hl("WhichKeyTitle",     { fg = p.red, bg = p.lgray, bold = true })
hl("WhichKey",          { fg = p.red, bold = true })
hl("WhichKeyGroup",     { fg = p.magenta, bold = true })
hl("WhichKeyDesc",      { fg = p.black })
hl("WhichKeySeparator", { fg = p.dgray })

-- indent-blankline
hl("IblIndent",     { fg = p.blue_dim })
hl("IblWhitespace", { fg = p.blue_dim })
hl("IblScope",      { fg = p.lblue })

-- oil.nvim
hl("OilDir",        { fg = p.white, bold = true })
hl("OilDirIcon",    { fg = p.white })
hl("OilLink",       { fg = p.lcyan })
hl("OilSocket",     { fg = p.lmagenta })
hl("OilFile",       { fg = p.yellow })

-- trouble
hl("TroubleNormal",   { fg = p.yellow, bg = p.blue })
hl("TroubleNormalNC", { fg = p.yellow, bg = p.blue })

-- lazy.nvim manager UI
hl("LazyNormal",     { fg = p.yellow, bg = p.blue })
hl("LazyButton",     { fg = p.black, bg = p.lgray })
hl("LazyButtonActive", { fg = p.black, bg = p.cyan, bold = true })
hl("LazyH1",         { fg = p.black, bg = p.cyan, bold = true })

-- mason UI
hl("MasonNormal",             { fg = p.yellow, bg = p.blue })
hl("MasonHeader",             { fg = p.black, bg = p.cyan, bold = true })
hl("MasonHighlight",          { fg = p.lgreen })
hl("MasonHighlightBlock",     { fg = p.black, bg = p.cyan })
hl("MasonHighlightBlockBold", { fg = p.black, bg = p.cyan, bold = true })
hl("MasonMuted",              { fg = p.lgray })
hl("MasonMutedBlock",         { fg = p.black, bg = p.lgray })

-- ── :terminal gets the DOS palette too ─────────────────────────────
vim.g.terminal_color_0  = p.black
vim.g.terminal_color_1  = p.red
vim.g.terminal_color_2  = p.green
vim.g.terminal_color_3  = p.brown
vim.g.terminal_color_4  = p.blue
vim.g.terminal_color_5  = p.magenta
vim.g.terminal_color_6  = p.cyan
vim.g.terminal_color_7  = p.lgray
vim.g.terminal_color_8  = p.dgray
vim.g.terminal_color_9  = p.lred
vim.g.terminal_color_10 = p.lgreen
vim.g.terminal_color_11 = p.yellow
vim.g.terminal_color_12 = p.lblue
vim.g.terminal_color_13 = p.lmagenta
vim.g.terminal_color_14 = p.lcyan
vim.g.terminal_color_15 = p.white
