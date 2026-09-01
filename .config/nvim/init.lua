-- ~/.config/nvim/init.lua

vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~/.local/bin")

vim.g.mapleader = " "

require("config.lazy")

-- Номера строк слева
vim.opt.number = true
vim.opt.relativenumber = true

-- Undo можно делать вечно
vim.opt.undofile = true

-- Улучшенный тайлинг
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Табуляция с 4 пробелами
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0

-- Убрать надпись legacy режима 
vim.opt.showmode = false
