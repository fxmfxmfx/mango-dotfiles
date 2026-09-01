return {
  "echasnovski/mini.statusline",
  version = false,
  config = function()
    require("mini.statusline").setup({
      use_icons = true,
    })

    local hl = vim.api.nvim_set_hl
    hl(0, "MiniStatuslineModeNormal",  { fg = "#f2ead9", bg = "#584f3f", bold = true })
    hl(0, "MiniStatuslineModeInsert",  { fg = "#f2ead9", bg = "#8a9268", bold = true })
    hl(0, "MiniStatuslineModeVisual",  { fg = "#f2ead9", bg = "#9c7d87", bold = true })
    hl(0, "MiniStatuslineModeReplace", { fg = "#f2ead9", bg = "#a9695a", bold = true })
    hl(0, "MiniStatuslineModeCommand", { fg = "#f2ead9", bg = "#b0925e", bold = true })
    hl(0, "MiniStatuslineModeOther",   { fg = "#f2ead9", bg = "#7c8c84", bold = true })

    hl(0, "MiniStatuslineDevinfo",     { fg = "#584f3f", bg = "#ddd0ac" })
    hl(0, "MiniStatuslineFilename",    { fg = "#6b6350", bg = "#f2ead9" })
    hl(0, "MiniStatuslineFileinfo",    { fg = "#584f3f", bg = "#ddd0ac" })
    hl(0, "MiniStatuslineInactive",    { fg = "#6b6350", bg = "#f2ead9" })
  end,
}
