-- markdown.lua
-- Author: Kyle Krstulich
-- Date: 2025-05-20

return {
  {
    'OXY2DEV/markview.nvim',
    ft = { 'markdown', 'quarto' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('markview').setup {
        preview = {
          enable = true,
        },
      }

      vim.keymap.set('n', '<localleader>ap', '<cmd>Markview<cr>', { desc = 'Toggle Markview preview' })
      vim.keymap.set('n', '<localleader>as', '<cmd>Markview splitOpen<cr>', { desc = 'Open Markview split' })
      vim.keymap.set('n', '<localleader>aS', '<cmd>Markview splitClose<cr>', { desc = 'Close Markview split' })
    end,
  },
}
