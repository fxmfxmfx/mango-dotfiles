-- Editor colors: Domino Still Life
local C = {
    bg = "#0c0c0c",
    fg = "#e6e6e6",

    shadow = "#17160f",
    shadow_bright = "#4a4634",

    wood = "#7b3428",
    wood_bright = "#c05a3e",

    olive = "#687244",
    olive_bright = "#a0aa6b",

    brass = "#9b7632",
    brass_bright = "#d0aa56",

    stone = "#58675f",
    stone_bright = "#8aa09a",

    wine = "#74515a",
    wine_bright = "#b27a86",

    oxid = "#6f7f69",
    oxid_bright = "#a3b89b",

    paper = "#c8bd98",
    bone = "#f3ead0",

    selection = "#2f3549",
    comment = "#7f8466",
    muted = "#6f6a52",
    panel = "#15140f",
    panel_soft = "#1d1b13",
}

local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

local function apply_editor_highlights()
    local transparent_groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "SignColumn",
        "EndOfBuffer",
        "LineNr",
        "FoldColumn",
        "StatusLine",
        "StatusLineNC",
    }

    for _, group in ipairs(transparent_groups) do
        hl(group, { bg = "NONE" })
    end

    -- Base UI
    hl("Normal", { fg = C.fg, bg = "NONE" })
    hl("NormalNC", { fg = C.fg, bg = "NONE" })
    hl("NormalFloat", { fg = C.fg, bg = "NONE" })
    hl("FloatBorder", { fg = C.brass, bg = "NONE" })
    hl("WinBar", { fg = C.paper, bg = "NONE" })
    hl("WinBarNC", { fg = C.muted, bg = "NONE" })
    hl("StatusLine", { fg = C.paper, bg = "NONE" })
    hl("StatusLineNC", { fg = C.muted, bg = "NONE" })

    hl("CursorLine", { bg = "#15140f" })
    hl("CursorLineNr", { fg = C.brass_bright, bold = true })
    hl("LineNr", { fg = C.shadow_bright })
    hl("SignColumn", { bg = "NONE" })
    hl("ColorColumn", { bg = C.panel })

    hl("Visual", { fg = C.bone, bg = C.selection })
    hl("Search", { fg = C.shadow, bg = C.brass_bright })
    hl("IncSearch", { fg = C.shadow, bg = C.wood_bright })

    hl("Pmenu", { fg = C.fg, bg = C.panel })
    hl("PmenuSel", { fg = C.bone, bg = C.selection, bold = true })
    hl("PmenuSbar", { bg = C.panel_soft })
    hl("PmenuThumb", { bg = C.brass })

    hl("TermNormal", { fg = C.fg, bg = "#1a1811" })
    hl("TermNormalNC", { fg = C.fg, bg = "#1a1811" })

    -- Legacy syntax
    hl("Comment", { fg = C.comment, italic = true })
    hl("String", { fg = C.olive_bright })
    hl("Character", { fg = C.olive_bright })
    hl("Number", { fg = C.brass_bright })
    hl("Boolean", { fg = C.wood_bright, bold = true })
    hl("Float", { fg = C.brass_bright })
    hl("Function", { fg = C.stone_bright, bold = true })
    hl("Identifier", { fg = C.fg })
    hl("Keyword", { fg = C.brass_bright, bold = true, italic = true })
    hl("Statement", { fg = C.brass_bright, bold = true })
    hl("Conditional", { fg = C.brass_bright, bold = true })
    hl("Repeat", { fg = C.brass_bright, bold = true })
    hl("Operator", { fg = C.paper })
    hl("Type", { fg = C.oxid_bright, italic = true })
    hl("Constant", { fg = C.paper })
    hl("Special", { fg = C.wine_bright })
    hl("PreProc", { fg = C.wine_bright })
    hl("Todo", { fg = C.shadow, bg = C.brass_bright, bold = true })

    -- Diagnostics
    hl("DiagnosticError", { fg = C.wood_bright })
    hl("DiagnosticWarn", { fg = C.brass_bright })
    hl("DiagnosticInfo", { fg = C.stone_bright })
    hl("DiagnosticHint", { fg = C.oxid_bright })
    hl("DiagnosticOk", { fg = C.olive_bright })

    -- Treesitter
    local syntax_groups = {
        ["@comment"] = { fg = C.comment, italic = true },

        ["@keyword"] = { fg = C.brass_bright, bold = true, italic = true },
        ["@keyword.function"] = { fg = C.brass_bright, bold = true },
        ["@keyword.return"] = { fg = C.wood_bright, bold = true },
        ["@keyword.conditional"] = { fg = C.brass_bright, bold = true },
        ["@keyword.repeat"] = { fg = C.brass_bright, bold = true },

        ["@function"] = { fg = C.stone_bright, bold = true },
        ["@function.call"] = { fg = C.stone_bright },
        ["@function.method"] = { fg = C.stone_bright },
        ["@method"] = { fg = C.stone_bright },
        ["@constructor"] = { fg = C.brass_bright, bold = true },

        ["@type"] = { fg = C.oxid_bright },
        ["@type.builtin"] = { fg = C.oxid_bright, italic = true },

        ["@string"] = { fg = C.olive_bright },
        ["@string.escape"] = { fg = C.brass_bright },
        ["@number"] = { fg = C.brass_bright },
        ["@boolean"] = { fg = C.wood_bright, bold = true },

        ["@constant"] = { fg = C.paper },
        ["@constant.builtin"] = { fg = C.wood_bright, bold = true },

        ["@variable"] = { fg = C.fg },
        ["@variable.builtin"] = { fg = C.wine_bright, italic = true },
        ["@variable.member"] = { fg = C.wine_bright },
        ["@property"] = { fg = C.wine_bright },

        ["@operator"] = { fg = C.paper },
        ["@punctuation.delimiter"] = { fg = C.muted },
        ["@punctuation.bracket"] = { fg = C.paper },
        ["@punctuation.special"] = { fg = C.brass },

        ["@tag"] = { fg = C.wood_bright },
        ["@tag.attribute"] = { fg = C.brass_bright, italic = true },
        ["@tag.delimiter"] = { fg = C.muted },

        ["@markup.heading"] = { fg = C.brass_bright, bold = true },
        ["@markup.link"] = { fg = "#88c0d0", underline = true },
        ["@markup.raw"] = { fg = C.olive_bright },
        ["@markup.list"] = { fg = C.wood_bright },

        RainbowDelimiterRed = { fg = C.wood_bright },
        RainbowDelimiterOrange = { fg = C.brass },
        RainbowDelimiterYellow = { fg = C.brass_bright },
        RainbowDelimiterGreen = { fg = C.olive_bright },
        RainbowDelimiterCyan = { fg = C.oxid_bright },
        RainbowDelimiterBlue = { fg = C.stone_bright },
        RainbowDelimiterViolet = { fg = C.wine_bright },
    }

    for group, opts in pairs(syntax_groups) do
        hl(group, opts)
    end

    -- Telescope
    hl("TelescopeNormal", { fg = C.fg, bg = "NONE" })
    hl("TelescopeBorder", { fg = C.brass, bg = "NONE" })
    hl("TelescopePromptBorder", { fg = C.brass_bright, bg = "NONE" })
    hl("TelescopePromptTitle", { fg = C.shadow, bg = C.brass_bright, bold = true })
    hl("TelescopeSelection", { fg = C.bone, bg = C.selection, bold = true })
    hl("TelescopeMatching", { fg = C.brass_bright, bold = true })

    -- NvimTree
    local tree_groups = {
        NvimTreeNormal = { fg = C.fg, bg = "NONE" },
        NvimTreeNormalNC = { fg = C.fg, bg = "NONE" },
        NvimTreeEndOfBuffer = { fg = C.shadow, bg = "NONE" },
        NvimTreeWinSeparator = { fg = C.shadow_bright, bg = "NONE" },
        NvimTreeCursorLine = { bg = C.panel },
        NvimTreeLineNr = { fg = C.shadow_bright },

        NvimTreeRootFolder = { fg = C.brass_bright, bold = true },
        NvimTreeFolderName = { fg = C.oxid_bright },
        NvimTreeOpenedFolderName = { fg = C.stone_bright, bold = true },
        NvimTreeEmptyFolderName = { fg = C.muted, italic = true },
        NvimTreeFolderIcon = { fg = C.oxid_bright },
        NvimTreeOpenedFolderIcon = { fg = C.stone_bright },
        NvimTreeFileIcon = { fg = C.fg },
        NvimTreeSymlink = { fg = C.oxid_bright, italic = true },
        NvimTreeExecFile = { fg = C.stone_bright, bold = true },
        NvimTreeSpecialFile = { fg = C.wine_bright, italic = true },
        NvimTreeImageFile = { fg = C.wine_bright },
        NvimTreeMarkdownFile = { fg = C.olive_bright },
        NvimTreeIndentMarker = { fg = C.shadow_bright },

        NvimTreeGitDirty = { fg = C.brass_bright },
        NvimTreeGitStaged = { fg = C.olive_bright },
        NvimTreeGitMerge = { fg = C.wine_bright },
        NvimTreeGitRenamed = { fg = C.oxid_bright },
        NvimTreeGitNew = { fg = C.olive_bright },
        NvimTreeGitDeleted = { fg = C.wood_bright },
        NvimTreeGitIgnored = { fg = C.muted, italic = true },

        NvimTreeDiagnosticError = { fg = C.wood_bright },
        NvimTreeDiagnosticWarn = { fg = C.brass_bright },
        NvimTreeDiagnosticInfo = { fg = C.stone_bright },
        NvimTreeDiagnosticHint = { fg = C.oxid_bright },
    }

    for group, opts in pairs(tree_groups) do
        hl(group, opts)
    end

    -- Alpha dashboard
    hl("AlphaHeader", { fg = C.brass })
    hl("AlphaButtons", { fg = C.paper })
    hl("AlphaShortcut", { fg = C.wood_bright, bold = true })
    hl("AlphaFooter", { fg = C.olive_bright, italic = true })
end

-- Base settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.g.mapleader = " "

vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = apply_editor_highlights,
})
apply_editor_highlights()

local treesitter_languages = {
    "bash",
    "c",
    "cpp",
    "css",
    "diff",
    "dockerfile",
    "fish",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "nix",
    "python",
    "query",
    "regex",
    "rust",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
}

vim.g.rainbow_delimiters = {
    highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterOrange",
        "RainbowDelimiterYellow",
        "RainbowDelimiterGreen",
        "RainbowDelimiterCyan",
        "RainbowDelimiterBlue",
        "RainbowDelimiterViolet",
    },
}

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.wo.winhighlight = "Normal:TermNormal,NormalNC:TermNormalNC,SignColumn:TermNormal,EndOfBuffer:TermNormal"
    end,
})

vim.keymap.set("v", "<C-M-c>", '"+y', { desc = "Copy selection to system clipboard" })
vim.keymap.set("v", "\27[99;7u", '"+y', { desc = "Copy selection to system clipboard" })

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
    {
        "goolord/alpha-nvim",
        config = function()
        require'alpha'.setup(require'alpha.themes.startify'.config)
        end,
    },
    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Top bar (breadcrumbs)
    {
        "utilyre/barbecue.nvim",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("barbecue").setup({
                theme = {
                    normal = { fg = C.paper, bg = "NONE" },

                    ellipsis = { fg = C.muted },
                    separator = { fg = C.shadow_bright },
                    modified = { fg = C.wood_bright },

                    dirname = { fg = C.muted },
                    basename = { fg = C.brass_bright, bold = true },
                    context = { fg = C.paper },

                    context_file = { fg = C.paper },
                    context_module = { fg = C.oxid_bright },
                    context_namespace = { fg = C.oxid_bright },
                    context_package = { fg = C.oxid_bright },
                    context_class = { fg = C.oxid_bright, bold = true },
                    context_method = { fg = C.stone_bright },
                    context_property = { fg = C.wine_bright },
                    context_field = { fg = C.wine_bright },
                    context_constructor = { fg = C.brass_bright, bold = true },
                    context_enum = { fg = C.oxid_bright },
                    context_interface = { fg = C.oxid_bright, italic = true },
                    context_function = { fg = C.stone_bright, bold = true },
                    context_variable = { fg = C.fg },
                    context_constant = { fg = C.paper },
                    context_string = { fg = C.olive_bright },
                    context_number = { fg = C.brass_bright },
                    context_boolean = { fg = C.wood_bright, bold = true },
                    context_array = { fg = C.brass },
                    context_object = { fg = C.brass },
                    context_key = { fg = C.wine_bright },
                    context_null = { fg = C.muted },
                    context_enum_member = { fg = C.wine_bright },
                    context_struct = { fg = C.oxid_bright },
                    context_event = { fg = C.wine_bright },
                    context_operator = { fg = C.paper },
                    context_type_parameter = { fg = C.oxid_bright, italic = true },
                },
                context_follow_icon_color = true,
            })
        end,
    },

    -- Russian keyboard layout mapping
    {
        "Wansmer/langmapper.nvim",
        lazy = false,
        priority = 1,
        config = function()
            require("langmapper").setup()
        end
    },

    -- File manager
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
            apply_editor_highlights()
            vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
        end
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
            vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
        end
    },

    -- Syntax highlighting and code parsing
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        config = function()
            local ok, configs = pcall(require, "nvim-treesitter.configs")
            if not ok then
                return
            end

            configs.setup({
                ensure_installed = treesitter_languages,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },

    -- Colored delimiter pairs
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = { "BufReadPost", "BufNewFile" },
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                },
            })
        end
    },

})

-- Configure lualine
require('lualine').setup {
    options = {
        theme = {
    normal = {
        a = { fg = "#0c0c0c", bg = "#9b7632", gui = "bold" },
        b = { fg = "#e6e6e6", bg = "#1d1b13" },
        c = { fg = "#c8bd98", bg = "NONE" },
    },
    insert = {
        a = { fg = "#0c0c0c", bg = "#8aa09a", gui = "bold" },
        b = { fg = "#e6e6e6", bg = "#1d1b13" },
        c = { fg = "#c8bd98", bg = "NONE" },
    },
    visual = {
        a = { fg = "#0c0c0c", bg = "#b27a86", gui = "bold" },
        b = { fg = "#e6e6e6", bg = "#1d1b13" },
        c = { fg = "#c8bd98", bg = "NONE" },
    },
    replace = {
        a = { fg = "#0c0c0c", bg = "#c05a3e", gui = "bold" },
        b = { fg = "#e6e6e6", bg = "#1d1b13" },
        c = { fg = "#c8bd98", bg = "NONE" },
    },
    command = {
        a = { fg = "#0c0c0c", bg = "#d0aa56", gui = "bold" },
        b = { fg = "#e6e6e6", bg = "#1d1b13" },
        c = { fg = "#c8bd98", bg = "NONE" },
    },
    inactive = {
        a = { fg = "#6f6a52", bg = "NONE" },
        b = { fg = "#6f6a52", bg = "NONE" },
        c = { fg = "#6f6a52", bg = "NONE" },
    },
},
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
}
apply_editor_highlights()
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

local footer_msgs = {
  "nvim",
  "fastfetch",
  "cmatrix",
  "neo",
  "emerge",
  "ls",
  "cd",
  "smallfetch",
  "grub-mkconfig",
  "doas",
  "mkdir",
  "cat",
  "less",
  "> /dev/null",
  "footclient",
  "rc-update",
  "rc-service",
  "lsblk",
  "killall",
  "pkill",
  "arch-chroot",
  "exit",
  "make",
  "rm",
  "gcc",
  "fish",
  "bash",
  "pls",
  "cp",
  "mount",
  "imv",
  "mpv"
}

math.randomseed(os.time())
local function random_footer()
  return footer_msgs[math.random(#footer_msgs)]
end

dashboard.section.footer.val = {
  random_footer()
}

alpha.setup(dashboard.config)

-- Header (ASCII)
dashboard.section.header.val = {
    "   ________  ________  ________  ________   ________  ________ ",
    "  ╱    ╱   ╲╱        ╲╱        ╲╱    ╱   ╲ ╱        ╲╱        ╲",
    " ╱         ╱         ╱         ╱         ╱_╱       ╱╱         ╱",
    "╱         ╱        _╱         ╱╲        ╱╱         ╱         ╱ ",
    "╲__╱_____╱╲________╱╲________╱  ╲______╱ ╲________╱╲__╱__╱__╱  ",
}

-- Buttons
dashboard.section.buttons.val = {
  dashboard.button("e", "new file", ":ene <BAR> startinsert<CR>"),
  dashboard.button("f", "find file", ":Telescope find_files<CR>"),
  dashboard.button("r", "recent", ":Telescope oldfiles<CR>"),
  dashboard.button("c", "config", ":lua OpenMyConfigs()<CR>"),
  dashboard.button("q", "quit", ":qa<CR>"),
}


alpha.setup(dashboard.config)

require("telescope").setup({
  defaults = {
    borderchars = {
      "─", -- top
      "│", -- right
      "─", -- bottom
      "│", -- left
      "┌", -- top-left
      "┐", -- top-right
      "┘", -- bottom-right
      "└", -- bottom-left
    },
  },
})

function OpenMyConfigs()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local configs = {
    { name = "nvim", path = vim.fn.expand("~/.config/nvim/init.lua") },
    { name = "mango", path = vim.fn.expand("~/.config/mango/config.conf") },
    { name = "foot", path = vim.fn.expand("~/.config/foot/foot.ini") },
    { name = "fuzzel", path = vim.fn.expand("~/.config/fuzzel/fuzzel.ini") },
  }

  pickers.new({}, {
    prompt_title = "Configs",
    initial_mode = "normal",
    finder = finders.new_table({
      results = configs,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name .. " -> " .. entry.path,
          ordinal = entry.name .. " " .. entry.path,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("edit " .. vim.fn.fnameescape(selection.value.path))
      end)
      return true
    end,
  }):find()
end
