vim.keymap.set('n', '<LocalLeader>au', ':InoUpload<CR>', { silent = true }) -- Upload code
vim.keymap.set('n', '<LocalLeader>ac', ':InoCheck<CR>', { silent = true }) -- Compile/check code
vim.keymap.set('n', '<LocalLeader>as', ':InoStatus<CR>', { silent = true }) -- Show current board and port status
vim.keymap.set('n', '<LocalLeader>ag', ':InoGUI<CR>', { silent = true }) -- Open GUI for setting board and port
vim.keymap.set('n', '<LocalLeader>am', ':InoMonitor<CR>', { silent = true }) -- Open Serial monitor with default port and baud rate
vim.keymap.set('n', '<LocalLeader>al', ':InoLib<CR>', { silent = true })
vim.keymap.set('n', '<LocalLeader>ab', ':InoSelectBoard<CR>', { silent = true }) -- open board selection gui
vim.keymap.set('n', '<LocalLeader>ap', ':InoSelectPort<CR>', { silent = true }) -- open board selection gui

vim.keymap.set('n', '<Esc>', function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == 'editor' then
      vim.api.nvim_win_close(win, false)
    end
  end
end, { silent = true, noremap = true })

return {}
