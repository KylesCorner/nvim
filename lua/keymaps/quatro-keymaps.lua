local runner = require 'quarto.runner'
vim.keymap.set('n', '<localleader>qc', runner.run_cell, { desc = 'run cell', silent = true })
vim.keymap.set('n', '<localleader>qa', runner.run_above, { desc = 'run cell and above', silent = true })
vim.keymap.set('n', '<localleader>qA', runner.run_all, { desc = 'run all cells', silent = true })
vim.keymap.set('n', '<localleader>ql', runner.run_line, { desc = 'run line', silent = true })
vim.keymap.set('v', '<localleader>qr', runner.run_range, { desc = 'run visual range', silent = true })
