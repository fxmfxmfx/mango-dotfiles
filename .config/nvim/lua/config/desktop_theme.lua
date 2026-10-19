-- One palette shared with desktop-theme; no external colorscheme dependency.
local M = {}
local root = vim.fn.expand("$XDG_CONFIG_HOME")
if root == "$XDG_CONFIG_HOME" or root == "" then root = vim.fn.expand("~/.config") end
root = root .. "/desktop-themes"

function M.apply()
  local file = io.open(root .. "/active.json", "r")
  local selected
  if not file then
    local current = io.open(root .. "/current", "r")
    selected = current and current:read("*l") or "cflowers"
    if current then current:close() end
    if not selected or not selected:match("^[%w_-]+$") then return false end
    file = io.open(root .. "/themes/" .. selected .. ".json", "r")
  end
  if not file then return false end
  local text = file:read("*a")
  file:close()
  local ok, p = pcall(vim.json.decode, text)
  if not ok or type(p) ~= "table" or type(p.terminal) ~= "table" then return false end
  p.name = p.name or selected
  if type(p.name) ~= "string" then return false end
  local defaults = {
    background = p.bg, foreground = p.fg,
    ["selection-background"] = p.bg_soft, ["selection-foreground"] = p.fg,
    urls = p.accent,
  }
  for key, value in pairs(defaults) do p.terminal[key] = p.terminal[key] or value end
  local t = p.terminal
  local function rgb(value) return "#" .. value end
  local bg, fg = rgb(t.background), rgb(t.foreground)
  local sel_bg, sel_fg = rgb(t["selection-background"]), rgb(t["selection-foreground"])
  local c = {}
  local names = { "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white" }
  for i, name in ipairs(names) do
    c[name], c["br_" .. name] = rgb(t["regular" .. (i - 1)]), rgb(t["bright" .. (i - 1)])
    vim.g["terminal_color_" .. (i - 1)] = c[name]
    vim.g["terminal_color_" .. (i + 7)] = c["br_" .. name]
  end
  local n = p.nvim or {}
  local surface = rgb(n.surface or p.bg_alt)
  local comment = rgb(n.comment or p.muted)
  local s = {}
  local defaults = {
    status_fg = p.bg, status_normal = p.accent, status_insert = p.green,
    status_visual = t.bright5, status_replace = p.urgent,
    status_command = t.bright3, status_other = t.bright6,
    status_info = p.bg_alt,
  }
  for key, value in pairs(defaults) do s[key] = rgb(n[key] or value) end
  vim.opt.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "desktop-" .. p.name
  local hl = vim.api.nvim_set_hl
  hl(0, "Normal",          { fg = fg, bg = bg })
  hl(0, "NormalFloat",     { fg = fg, bg = bg })
  hl(0, "EndOfBuffer",     { fg = bg })
  hl(0, "CursorLine",      { bg = surface })
  hl(0, "CursorLineNr",    { fg = c.br_white, bg = surface, bold = true })
  hl(0, "CursorColumn",    { bg = surface })
  hl(0, "ColorColumn",     { bg = surface })
  hl(0, "LineNr",          { fg = c.br_black })
  hl(0, "SignColumn",      { fg = fg, bg = bg })
  hl(0, "VertSplit",       { fg = c.br_black, bg = bg })
  hl(0, "Folded",          { fg = c.br_black, bg = surface })
  hl(0, "FoldColumn",      { fg = c.br_black, bg = bg })
  hl(0, "MatchParen",      { fg = c.yellow, bold = true })

  hl(0, "Visual",          { fg = sel_fg, bg = sel_bg })
  hl(0, "VisualNOS",       { fg = sel_fg, bg = sel_bg })

  hl(0, "Pmenu",           { fg = fg, bg = surface })
  hl(0, "PmenuSel",        { fg = bg, bg = c.br_cyan })
  hl(0, "PmenuSbar",       { bg = surface })
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

  hl(0, "debugPC",         { bg = surface })
  hl(0, "debugBreakpoint", { fg = c.red, bg = bg })

  -- Syntax
  hl(0, "Comment",        { fg = comment, italic = true })
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
  hl(0, "LspInlayHint",              { fg = c.br_black, bg = surface })

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
  hl(0, "NvimTreeCursorLine",        { bg = surface })
  hl(0, "NvimTreeCursorColumn",      { bg = surface })
  hl(0, "NvimTreeSymlink",           { fg = c.br_cyan })
  hl(0, "NvimTreeFolderName",        { fg = c.br_blue })
  hl(0, "NvimTreeFolderIcon",        { fg = c.br_blue })
  hl(0, "NvimTreeEmptyFolderName",   { fg = c.br_black })
  hl(0, "NvimTreeOpenedFolderName",  { fg = c.br_blue })
  hl(0, "NvimTreeIndentMarker",      { fg = c.br_black })
  local hl = vim.api.nvim_set_hl
  hl(0, "MiniStatuslineModeNormal",  { fg = s.status_fg, bg = s.status_normal, bold = true })
  hl(0, "MiniStatuslineModeInsert",  { fg = s.status_fg, bg = s.status_insert, bold = true })
  hl(0, "MiniStatuslineModeVisual",  { fg = s.status_fg, bg = s.status_visual, bold = true })
  hl(0, "MiniStatuslineModeReplace", { fg = s.status_fg, bg = s.status_replace, bold = true })
  hl(0, "MiniStatuslineModeCommand", { fg = s.status_fg, bg = s.status_command, bold = true })
  hl(0, "MiniStatuslineModeOther",   { fg = s.status_fg, bg = s.status_other, bold = true })

  hl(0, "MiniStatuslineDevinfo",     { fg = s.status_normal, bg = s.status_info })
  hl(0, "MiniStatuslineFilename",    { fg = comment, bg = s.status_fg })
  hl(0, "MiniStatuslineFileinfo",    { fg = s.status_normal, bg = s.status_info })
  hl(0, "MiniStatuslineInactive",    { fg = comment, bg = s.status_fg })
  vim.g.desktop_theme = p.name
  vim.cmd("redraw")
  return true
end

function M.setup()
  M.apply()
  if M.watcher then return true end
  local uv = vim.uv or vim.loop
  M.watcher = uv.new_fs_event()
  local ok = M.watcher:start(root, {}, vim.schedule_wrap(function(err, filename)
    if not err and (filename == "active.json" or filename == nil) then M.apply() end
  end))
  if not ok then M.watcher:close(); M.watcher = nil end
  local group = vim.api.nvim_create_augroup("DesktopTheme", { clear = true })
  vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, { group = group, callback = M.apply })
  vim.api.nvim_create_autocmd("VimLeavePre", { group = group, callback = function()
    if M.watcher then M.watcher:stop(); M.watcher:close(); M.watcher = nil end
  end })
  return true
end

return M
