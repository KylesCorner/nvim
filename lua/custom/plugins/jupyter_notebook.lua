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
return {
  {
    --backend
    'dccsillag/magma-nvim',
    build = ':UpdateRemotePlugins',
    config = function()
      vim.cmd 'let g:magma_automatically_open_output = v:true'
      vim.cmd 'let g:magma_output_window_borders= v:true'
      vim.keymap.set('n', '<localleader>mo', ':MagmaEvaluateOperator<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>ml', ':MagmaEvaluateLine<CR>', { silent = true })
      vim.keymap.set('x', '<localleader>mv', ':<C-u>MagmaEvaluateVisual<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mc', ':MagmaReevaluateCell<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>md', ':MagmaDelete<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mo', ':MagmaShowOutput<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mi', ':MagmaInit<CR>', { silent = true })
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
