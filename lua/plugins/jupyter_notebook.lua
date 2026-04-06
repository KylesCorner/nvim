return {
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    lazy = false,
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
    end,
    -- config = function()
    --   vim.keymap.set('n', '<localleader>mi', ':MoltenInit<CR>', { silent = true, desc = 'Molten init' })
    --   vim.keymap.set('n', '<localleader>ml', ':MoltenEvaluateLine<CR>', { silent = true, desc = 'Molten eval line' })
    --   vim.keymap.set('v', '<localleader>mv', ':<C-u>MoltenEvaluateVisual<CR>', { silent = true, desc = 'Molten eval visual' })
    --   vim.keymap.set('n', '<localleader>mo', ':MoltenShowOutput<CR>', { silent = true, desc = 'Molten show output' })
    --   vim.keymap.set('n', '<localleader>mr', ':MoltenReevaluateCell<CR>', { silent = true, desc = 'Molten re-eval cell' })
    --   vim.keymap.set('n', '<localleader>mx', ':MoltenInterrupt<CR>', { silent = true, desc = 'Molten interrupt' })
    --   vim.keymap.set('n', '<localleader>mR', ':MoltenRestart<CR>', { silent = true, desc = 'Molten restart' })
    --   vim.keymap.set('n', '<localleader>mI', ':MoltenInfo<CR>', { silent = true, desc = 'Molten info' })
    -- end,
  },

  {
    '3rd/image.nvim',
    opts = {
      backend = 'kitty',
      processor = 'magick_cli',
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating_windows = false,
          filetypes = { 'markdown', 'quarto' },
        },
      },
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    },
  },
  {
    'quarto-dev/quarto-nvim',
    ft = { 'quarto', 'markdown' },
    dependencies = {
      'jmbuhr/otter.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      lspFeatures = {
        enabled = true,
        chunks = 'all',
        languages = { 'python' },
        diagnostics = {
          enabled = true,
          triggers = { 'BufWritePost' },
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = true,
        default_method = 'molten',
      },
    },
    config = function(_, opts)
      require('quarto').setup(opts)
    end,
  },

  {
    'jmbuhr/otter.nvim',
    opts = {},
  },

  {
    'GCBallesteros/jupytext.nvim',
    lazy = false,
    config = function()
      require('jupytext').setup {
        style = 'markdown',
        output_extension = 'md',
        force_ft = 'markdown',
      }
    end,
  },
}
