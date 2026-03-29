local keymap = vim.keymap.set
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- replace escape with a quick jk
keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- Diagnostic keymaps
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
keymap('n', '<leader>e', ':Neotree reveal<CR>', { desc = 'Neotree Toggle' })
--
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- Toggle terminal
local terminal_buf = nil
local terminal_win = nil

local function toggle_terminal(split_type)
  -- Close terminal if already open
  if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
    vim.api.nvim_win_close(terminal_win, true)
    terminal_win = nil
    return
  end

  -- Open split
  if split_type == 'vertical' then
    vim.cmd 'vsplit'
  else
    vim.cmd 'split'
  end

  terminal_win = vim.api.nvim_get_current_win()

  -- Reuse buffer or open new terminal
  if terminal_buf and vim.api.nvim_buf_is_valid(terminal_buf) then
    vim.api.nvim_win_set_buf(terminal_win, terminal_buf)
  else
    vim.cmd 'terminal'
    terminal_buf = vim.api.nvim_get_current_buf()
  end

  vim.cmd 'startinsert'
end

keymap('n', '<leader>tv', function()
  toggle_terminal 'vertical'
end, { desc = 'Toggle vertical terminal' })

keymap('n', '<leader>ts', function()
  toggle_terminal 'horizontal'
end, { desc = 'Toggle horizontal terminal' })
return {}
