-- /ftplugin/python.lua
-- require 'keymaps.molten-keymaps'

-- Set indentation settings
vim.opt.breakindent = true
vim.opt.wrap = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

-- Define a key mapping for running the current Python file
vim.keymap.set('n', '<leader>pr', ':w<CR>:!python3 %<CR>', { buffer = true, desc = 'Run Python file' })
