-- /ftplugin/python.lua

-- Set indentation settings
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

-- Define a key mapping for running the current Python file
vim.keymap.set('n', '<localleader>pr', ':w<CR>:!python3 %<CR>', { buffer = true, desc = 'Run Python file' })
