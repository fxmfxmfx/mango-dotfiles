return {
  "echasnovski/mini.statusline",
  version = false,
  config = function()
    require("mini.statusline").setup({ use_icons = true })
    require("config.desktop_theme").apply()
  end,
}
