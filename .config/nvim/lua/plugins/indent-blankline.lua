return {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    opts = {
        -- можно настроить стиль линий, символы и т.п.
        -- пример: использовать `▏` вместо `│`
        indent = {
            char = "▏",
        },
    },
}
