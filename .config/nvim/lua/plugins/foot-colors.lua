return {
  { "rktjmp/lush.nvim", lazy = true },
  { "rktjmp/shipwright.nvim", lazy = true },
  {
    name = "foot-colors",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function() require("config.desktop_theme").setup() end,
  },
}
