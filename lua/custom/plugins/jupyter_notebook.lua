-- jupyter_notebook.lua
-- Author: Kyle Krstulich
-- Date: 2025-05-08
--[[
Edit the magma-nvim plugin file at:

~/.local/share/nvim/lazy/magma-nvim/rplugin/python3/magma/outputbuffer.py
Find the line (around line 116):

self.display_window = self.nvim.funcs.nvim_open_win(
Change the block that starts like this:

self.display_window = self.nvim.funcs.nvim_open_win(
    self.buffer.number, False, {
        "relative": "editor",
        "row": 2,
        "col": 10,
        "width": 50,
        "height": 10,
        # Add the missing line below:
        "style": "minimal"
    })
Add "style": "minimal" to the window options dict if it’s missing.

Then restart Neovim and run:

:UpdateRemotePlugins
And restart Neovim again.
--]]

-- Run Python code between triple backticks with Magma
function RunMagmaBlock()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_nr = cursor[1]

  local start_line = nil
  local end_line = nil

  -- Search upward for first ```
  for i = line_nr, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    if line:match '^```python' then
      start_line = i
      break
    end
  end

  -- Search downward for closing ```
  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  for i = line_nr + 1, total_lines do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    if line:match '^```' then
      end_line = i
      break
    end
  end

  -- Make sure the block is valid and exclude the backtick lines
  if start_line and end_line and (start_line + 1) < end_line then
    -- Select between the backticks
    vim.api.nvim_win_set_cursor(0, { start_line + 1, 0 })
    vim.cmd 'normal! V'
    vim.api.nvim_win_set_cursor(0, { end_line - 1, 0 })
    vim.cmd 'MagmaEvaluateVisual'
  else
    print 'Could not find valid code block between triple backticks.'
  end
end

return {
  {
    --backend
    'dccsillag/magma-nvim',
    build = ':UpdateRemotePlugins',
    config = function()
      vim.cmd 'let g:magma_automatically_open_output = v:true'
      vim.cmd 'let g:magma_output_window_borders= v:true'
      vim.cmd 'let g:magma_image_provider="kitty"'

      vim.keymap.set('n', '<localleader>mp', ':MagmaEvaluateOperator<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>ml', ':MagmaEvaluateLine<CR>', { silent = true })
      vim.keymap.set('x', '<localleader>mv', ':<C-u>MagmaEvaluateVisual<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mc', ':MagmaReevaluateCell<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>md', ':MagmaDelete<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mo', ':MagmaShowOutput<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mi', ':MagmaInit<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mb', RunMagmaBlock, { desc = 'Run magma block between backticks.' })
    end,
    ft = { 'python', 'julia', 'markdown' },
  },
  {
    --frontend
    'goerz/jupytext.nvim',
    version = '0.2.0',
    opts = {
      jupytext = 'jupytext',
      format = 'markdown',
      update = true,
      -- filetype = require('jupytext').get_filetype,
      -- new_template = require('jupytext').default_new_template(),
      sync_patterns = { '*.md', '*.py', '*.jl', '*.R', '*.Rmd', '*.qmd' },
      autosync = true,
      handle_url_schemes = true,
    },
  },
}
