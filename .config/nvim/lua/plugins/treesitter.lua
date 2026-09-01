return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSUpdate", "TSUninstall" },
  opts = {
    ensure_installed = {
      "c", "cpp", "lua", "vim", "vimdoc",
      "python", "rust", "go", "zig",
      "javascript", "typescript", "tsx",
      "html", "css", "json", "yaml", "toml",
      "markdown", "markdown_inline",
      "bash", "fish", "make",
      "gitignore", "diff",
      "sql", "regex",
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
  },
}
