return {
    "echasnovski/mini.pairs",
    version = false,
    config = function()
        require("mini.pairs").setup()

        -- Простой шаг вправо и влево
        vim.keymap.set('i', '<C-]>', '<Right>', { noremap = true })
        vim.keymap.set('i', '<C-[>', '<Left>', { noremap = true })

    end,
}
