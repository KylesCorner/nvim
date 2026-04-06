-- Molten keymaps
vim.keymap.set('n', '<localleader>mi', ':MoltenInit<CR>', { silent = true, desc = 'Molten init' })
vim.keymap.set('n', '<localleader>mI', ':MoltenInfo<CR>', { silent = true, desc = 'Molten info' })

-- evaluate
vim.keymap.set('n', '<localleader>me', ':MoltenEvaluateOperator<CR>', { silent = true, desc = 'Molten eval operator' })
vim.keymap.set('n', '<localleader>ml', ':MoltenEvaluateLine<CR>', { silent = true, desc = 'Molten eval line' })
vim.keymap.set('v', '<localleader>mv', ':<C-u>MoltenEvaluateVisual<CR>', { silent = true, desc = 'Molten eval visual' })
vim.keymap.set('n', '<localleader>mc', ':MoltenReevaluateCell<CR>', { silent = true, desc = 'Molten re-eval cell' })

-- output
vim.keymap.set('n', '<localleader>mo', ':MoltenShowOutput<CR>', { silent = true, desc = 'Molten show output' })
vim.keymap.set('n', '<localleader>mh', ':MoltenHideOutput<CR>', { silent = true, desc = 'Molten hide output' })
vim.keymap.set('n', '<localleader>mp', ':MoltenImagePopup<CR>', { silent = true, desc = 'Molten image popup' })
vim.keymap.set('n', '<localleader>mx', ':MoltenDelete<CR>', { silent = true, desc = 'Molten delete cell output' })

-- kernel control
vim.keymap.set('n', '<localleader>mX', ':MoltenInterrupt<CR>', { silent = true, desc = 'Molten interrupt' })
vim.keymap.set('n', '<localleader>mR', ':MoltenRestart<CR>', { silent = true, desc = 'Molten restart kernel' })

-- navigation
vim.keymap.set('n', ']m', ':MoltenNext<CR>', { silent = true, desc = 'Molten next cell' })
vim.keymap.set('n', '[m', ':MoltenPrev<CR>', { silent = true, desc = 'Molten previous cell' })

-- save/load outputs
vim.keymap.set('n', '<localleader>ms', ':MoltenSave<CR>', { silent = true, desc = 'Molten save outputs' })
vim.keymap.set('n', '<localleader>mL', ':MoltenLoad<CR>', { silent = true, desc = 'Molten load outputs' })
