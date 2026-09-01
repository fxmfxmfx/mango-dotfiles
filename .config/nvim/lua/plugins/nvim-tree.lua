return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- иконки файлов (опционально, но красиво)
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
        { "<C-n>", "<cmd>NvimTreeToggle<cr>", mode = "n", desc = "Toggle file tree" },
        { "<leader>e", "<cmd>NvimTreeFocus<cr>", mode = "n", desc = "Focus file tree" },
    },
    opts = {
        -- можно отключить netrw, если не нужен
        disable_netrw = true,
        hijack_netrw = true,
        view = {
            width = 30,
            side = "left",
        },
        -- настройка поведения при открытии файлов
        actions = {
            open_file = {
                quit_on_open = true, -- закрыть дерево при открытии файла (как VSCode)
            },
        },
        filters = {
            dotfiles = false, -- показывать скрытые файлы, если надо
        },
    },
}
