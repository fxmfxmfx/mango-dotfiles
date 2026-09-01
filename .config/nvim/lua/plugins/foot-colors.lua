return {
  {
    "rktjmp/lush.nvim",
    lazy = true,
  },
  {
    "rktjmp/shipwright.nvim",
    lazy = true,
  },
  {
    name = "foot-colors",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true

      local bg = "#0c0c0c"
      local fg = "#e6e6e6"
      local sel_bg = "#2f3549"
      local sel_fg = "#ffffff"

      local c = {
        black   = "#17160f",
        red     = "#7b3428",
        green   = "#687244",
        yellow  = "#9b7632",
        blue    = "#58675f",
        magenta = "#74515a",
        cyan    = "#6f7f69",
        white   = "#c8bd98",

        br_black   = "#4a4634",
        br_red     = "#c05a3e",
        br_green   = "#a0aa6b",
        br_yellow  = "#d0aa56",
        br_blue    = "#8aa09a",
        br_magenta = "#b27a86",
        br_cyan    = "#a3b89b",
        br_white   = "#f3ead0",
      }

      local hl = vim.api.nvim_set_hl
      hl(0, "Normal",          { fg = fg, bg = bg })
      hl(0, "NormalFloat",     { fg = fg, bg = bg })
      hl(0, "EndOfBuffer",     { fg = bg })
      hl(0, "CursorLine",      { bg = "#1a1a1a" })
      hl(0, "CursorLineNr",    { fg = c.br_white, bg = "#1a1a1a", bold = true })
      hl(0, "CursorColumn",    { bg = "#1a1a1a" })
      hl(0, "ColorColumn",     { bg = "#1a1a1a" })
      hl(0, "LineNr",          { fg = c.br_black })
      hl(0, "SignColumn",      { fg = fg, bg = bg })
      hl(0, "VertSplit",       { fg = c.br_black, bg = bg })
      hl(0, "Folded",          { fg = c.br_black, bg = "#1a1a1a" })
      hl(0, "FoldColumn",      { fg = c.br_black, bg = bg })
      hl(0, "MatchParen",      { fg = c.yellow, bold = true })

      hl(0, "Visual",          { fg = sel_fg, bg = sel_bg })
      hl(0, "VisualNOS",       { fg = sel_fg, bg = sel_bg })

      hl(0, "Pmenu",           { fg = fg, bg = "#1a1a1a" })
      hl(0, "PmenuSel",        { fg = bg, bg = c.br_cyan })
      hl(0, "PmenuSbar",       { bg = "#1a1a1a" })
      hl(0, "PmenuThumb",      { bg = c.br_black })

      hl(0, "Search",          { fg = bg, bg = c.yellow })
      hl(0, "CurSearch",       { fg = bg, bg = c.br_yellow })
      hl(0, "IncSearch",       { fg = bg, bg = c.br_yellow })

      hl(0, "Directory",       { fg = c.cyan })
      hl(0, "Title",           { fg = c.br_yellow, bold = true })

      hl(0, "Question",        { fg = c.green })
      hl(0, "MoreMsg",         { fg = c.green })
      hl(0, "WarningMsg",      { fg = c.yellow })
      hl(0, "ErrorMsg",        { fg = c.red, bold = true })

      hl(0, "SpellBad",        { fg = c.red, undercurl = true })
      hl(0, "SpellCap",        { fg = c.yellow, undercurl = true })
      hl(0, "SpellRare",       { fg = c.magenta, undercurl = true })
      hl(0, "SpellLocal",      { fg = c.cyan, undercurl = true })

      hl(0, "TabLine",         { fg = c.br_black, bg = bg })
      hl(0, "TabLineSel",      { fg = fg, bg = bg, bold = true })
      hl(0, "TabLineFill",     { fg = c.br_black, bg = bg })

      hl(0, "StatusLine",      { fg = fg, bg = bg })
      hl(0, "StatusLineNC",    { fg = c.br_black, bg = bg })

      hl(0, "Whitespace",      { fg = c.br_black })
      hl(0, "NonText",         { fg = c.br_black })
      hl(0, "SpecialKey",      { fg = c.br_black })

      hl(0, "Conceal",         { fg = c.br_black })

      hl(0, "DiffAdd",         { fg = c.green, bg = bg })
      hl(0, "DiffDelete",      { fg = c.red, bg = bg })
      hl(0, "DiffChange",      { fg = c.yellow, bg = bg })
      hl(0, "DiffText",        { fg = c.br_yellow, bg = bg })

      hl(0, "debugPC",         { bg = "#1a1a1a" })
      hl(0, "debugBreakpoint", { fg = c.red, bg = bg })

      -- Syntax
      hl(0, "Comment",        { fg = "#6b6350", italic = true })
      hl(0, "Constant",       { fg = c.br_magenta })
      hl(0, "String",         { fg = c.green })
      hl(0, "Character",      { fg = c.green })
      hl(0, "Number",         { fg = c.br_magenta })
      hl(0, "Boolean",        { fg = c.br_magenta })
      hl(0, "Float",          { fg = c.br_magenta })

      hl(0, "Identifier",     { fg = fg })
      hl(0, "Function",       { fg = c.br_cyan })

      hl(0, "Statement",      { fg = c.red })
      hl(0, "Conditional",    { fg = c.red })
      hl(0, "Repeat",         { fg = c.red })
      hl(0, "Label",          { fg = c.red })
      hl(0, "Operator",       { fg = c.br_white })
      hl(0, "Keyword",        { fg = c.red })
      hl(0, "Exception",      { fg = c.red })

      hl(0, "PreProc",        { fg = c.yellow })
      hl(0, "Include",        { fg = c.yellow })
      hl(0, "Define",         { fg = c.yellow })
      hl(0, "Macro",          { fg = c.yellow })
      hl(0, "PreCondit",      { fg = c.yellow })

      hl(0, "Type",           { fg = c.cyan })
      hl(0, "StorageClass",   { fg = c.cyan })
      hl(0, "Structure",      { fg = c.cyan })
      hl(0, "Typedef",        { fg = c.cyan })

      hl(0, "Special",        { fg = c.br_yellow })
      hl(0, "SpecialChar",    { fg = c.br_yellow })
      hl(0, "Tag",            { fg = c.br_yellow })
      hl(0, "Delimiter",      { fg = c.br_black })
      hl(0, "SpecialComment", { fg = c.br_black, italic = true })
      hl(0, "Debug",          { fg = c.red })

      hl(0, "Underlined",     { fg = c.br_blue, underline = true })
      hl(0, "Ignore",         { fg = bg })
      hl(0, "Error",          { fg = c.red, bg = bg })
      hl(0, "Todo",           { fg = bg, bg = c.yellow })

      -- Treesitter
      hl(0, "@comment",                 { link = "Comment" })
      hl(0, "@error",                   { link = "Error" })
      hl(0, "@none",                    {})
      hl(0, "@preproc",                 { link = "PreProc" })
      hl(0, "@define",                  { link = "Define" })
      hl(0, "@operator",                { link = "Operator" })

      hl(0, "@punctuation.delimiter",   { link = "Delimiter" })
      hl(0, "@punctuation.bracket",     { fg = fg })
      hl(0, "@punctuation.special",     { link = "Special" })

      hl(0, "@string",                  { link = "String" })
      hl(0, "@string.regex",            { fg = c.br_yellow })
      hl(0, "@string.escape",           { fg = c.br_yellow })
      hl(0, "@string.special",          { fg = c.br_yellow })

      hl(0, "@character",               { link = "Character" })
      hl(0, "@character.special",       { fg = c.br_yellow })

      hl(0, "@boolean",                 { link = "Boolean" })
      hl(0, "@number",                  { link = "Number" })
      hl(0, "@float",                   { link = "Float" })

      hl(0, "@function",                { link = "Function" })
      hl(0, "@function.builtin",        { fg = c.br_yellow })
      hl(0, "@function.call",           { link = "Function" })
      hl(0, "@function.macro",          { link = "Macro" })
      hl(0, "@function.method",         { link = "Function" })
      hl(0, "@function.method.call",    { link = "Function" })

      hl(0, "@parameter",               { fg = c.br_yellow })
      hl(0, "@parameter.reference",     { fg = c.br_yellow })

      hl(0, "@method",                  { link = "Function" })
      hl(0, "@method.call",             { link = "Function" })

      hl(0, "@field",                   { fg = c.br_cyan })
      hl(0, "@property",                { fg = c.br_cyan })

      hl(0, "@constructor",             { fg = c.br_cyan })

      hl(0, "@conditional",             { link = "Conditional" })
      hl(0, "@repeat",                  { link = "Repeat" })
      hl(0, "@label",                   { link = "Label" })
      hl(0, "@keyword",                 { link = "Keyword" })
      hl(0, "@keyword.conditional",     { link = "Conditional" })
      hl(0, "@keyword.repeat",          { link = "Repeat" })
      hl(0, "@keyword.return",          { fg = c.red })
      hl(0, "@keyword.exception",       { link = "Exception" })
      hl(0, "@keyword.function",        { fg = c.red })
      hl(0, "@keyword.operator",        { fg = c.br_white })

      hl(0, "@exception",               { link = "Exception" })

      hl(0, "@include",                 { link = "Include" })

      hl(0, "@variable",                { fg = fg })
      hl(0, "@variable.builtin",        { fg = c.br_magenta })

      hl(0, "@type",                    { link = "Type" })
      hl(0, "@type.builtin",            { fg = c.cyan, italic = true })
      hl(0, "@type.definition",         { link = "Typedef" })
      hl(0, "@type.qualifier",          { link = "Type" })

      hl(0, "@storageclass",            { fg = c.cyan })
      hl(0, "@attribute",               { fg = c.br_magenta })
      hl(0, "@annotation",              { fg = c.br_yellow })

      hl(0, "@namespace",               { fg = c.br_cyan })

      hl(0, "@symbol",                  { fg = c.br_magenta })

      hl(0, "@tag",                     { fg = c.red })
      hl(0, "@tag.attribute",           { fg = c.br_cyan })
      hl(0, "@tag.delimiter",           { fg = c.br_black })

      hl(0, "@text",                    { fg = fg })
      hl(0, "@text.strong",             { bold = true })
      hl(0, "@text.emphasis",           { italic = true })
      hl(0, "@text.underline",          { underline = true })
      hl(0, "@text.strike",             { strikethrough = true })
      hl(0, "@text.title",              { link = "Title" })
      hl(0, "@text.literal",            { fg = c.green })
      hl(0, "@text.uri",                { fg = c.br_blue, underline = true })
      hl(0, "@text.math",               { fg = c.br_magenta })
      hl(0, "@text.environment",        { fg = c.br_magenta })
      hl(0, "@text.environment.name",   { fg = c.br_cyan })
      hl(0, "@text.reference",          { fg = c.br_magenta })
      hl(0, "@text.todo",               { link = "Todo" })
      hl(0, "@text.note",               { fg = bg, bg = c.br_blue })
      hl(0, "@text.warning",            { fg = bg, bg = c.yellow })
      hl(0, "@text.danger",             { fg = bg, bg = c.red })
      hl(0, "@text.diff.add",           { fg = c.green })
      hl(0, "@text.diff.delete",        { fg = c.red })

      hl(0, "@diff.plus",               { link = "DiffAdd" })
      hl(0, "@diff.minus",              { link = "DiffDelete" })
      hl(0, "@diff.delta",              { link = "DiffChange" })

      -- LSP
      hl(0, "DiagnosticError",          { fg = c.red })
      hl(0, "DiagnosticWarn",           { fg = c.yellow })
      hl(0, "DiagnosticInfo",            { fg = c.br_blue })
      hl(0, "DiagnosticHint",           { fg = c.br_cyan })
      hl(0, "DiagnosticOk",             { fg = c.green })
      hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = c.red })
      hl(0, "DiagnosticUnderlineWarn",  { undercurl = true, sp = c.yellow })
      hl(0, "DiagnosticUnderlineInfo",  { undercurl = true, sp = c.br_blue })
      hl(0, "DiagnosticUnderlineHint",  { undercurl = true, sp = c.br_cyan })
      hl(0, "DiagnosticUnderlineOk",    { undercurl = true, sp = c.green })
      hl(0, "DiagnosticSignError",      { fg = c.red, bg = bg })
      hl(0, "DiagnosticSignWarn",       { fg = c.yellow, bg = bg })
      hl(0, "DiagnosticSignInfo",       { fg = c.br_blue, bg = bg })
      hl(0, "DiagnosticSignHint",       { fg = c.br_cyan, bg = bg })
      hl(0, "DiagnosticSignOk",         { fg = c.green, bg = bg })
      hl(0, "DiagnosticFloatingError",  { fg = c.red })
      hl(0, "DiagnosticFloatingWarn",   { fg = c.yellow })
      hl(0, "DiagnosticFloatingInfo",   { fg = c.br_blue })
      hl(0, "DiagnosticFloatingHint",   { fg = c.br_cyan })
      hl(0, "DiagnosticFloatingOk",     { fg = c.green })
      hl(0, "DiagnosticVirtualTextError", { fg = c.red })
      hl(0, "DiagnosticVirtualTextWarn",  { fg = c.yellow })
      hl(0, "DiagnosticVirtualTextInfo",  { fg = c.br_blue })
      hl(0, "DiagnosticVirtualTextHint",  { fg = c.br_cyan })
      hl(0, "DiagnosticVirtualTextOk",    { fg = c.green })

      hl(0, "LspReferenceText",           { bg = sel_bg })
      hl(0, "LspReferenceRead",           { bg = sel_bg })
      hl(0, "LspReferenceWrite",          { bg = sel_bg })
      hl(0, "LspInlayHint",              { fg = c.br_black, bg = "#1a1a1a" })

      hl(0, "LspSignatureActiveParameter", { fg = c.br_yellow, bold = true })

      -- NvimTree
      hl(0, "NvimTreeNormal",            { fg = fg, bg = bg })
      hl(0, "NvimTreeVertSplit",         { fg = bg, bg = bg })
      hl(0, "NvimTreeRootFolder",        { fg = c.br_magenta, bold = true })
      hl(0, "NvimTreeGitDirty",          { fg = c.yellow })
      hl(0, "NvimTreeGitNew",            { fg = c.green })
      hl(0, "NvimTreeGitDeleted",        { fg = c.red })
      hl(0, "NvimTreeGitStaged",         { fg = c.br_cyan })
      hl(0, "NvimTreeGitMerge",          { fg = c.red })
      hl(0, "NvimTreeGitRenamed",        { fg = c.br_blue })
      hl(0, "NvimTreeOpenedFile",        { fg = c.br_white })
      hl(0, "NvimTreeExecFile",          { fg = c.green })
      hl(0, "NvimTreeSpecialFile",       { fg = c.br_magenta })
      hl(0, "NvimTreeImageFile",         { fg = c.br_magenta })
      hl(0, "NvimTreeCursorLine",        { bg = "#1a1a1a" })
      hl(0, "NvimTreeCursorColumn",      { bg = "#1a1a1a" })
      hl(0, "NvimTreeSymlink",           { fg = c.br_cyan })
      hl(0, "NvimTreeFolderName",        { fg = c.br_blue })
      hl(0, "NvimTreeFolderIcon",        { fg = c.br_blue })
      hl(0, "NvimTreeEmptyFolderName",   { fg = c.br_black })
      hl(0, "NvimTreeOpenedFolderName",  { fg = c.br_blue })
      hl(0, "NvimTreeIndentMarker",      { fg = c.br_black })
    end,
  },
}
