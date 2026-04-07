return {
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    lazy = true,
    build = ':UpdateRemotePlugins',
    ft = { 'markdown', 'quarto', 'python' },
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_image_location = 'float'
    end,
    config = function()
      local function export_current_file(format)
        local file = vim.fn.expand '%:p'
        local ext = vim.fn.expand '%:e'
        local cmd

        if ext == 'ipynb' then
          if format == 'html' then
            cmd = { 'jupyter', 'nbconvert', '--to', 'html', file }
          elseif format == 'pdf' then
            cmd = { 'jupyter', 'nbconvert', '--to', 'pdf', file }
          else
            vim.notify('Unsupported export format: ' .. format, vim.log.levels.ERROR)
            return
          end
        elseif ext == 'qmd' or ext == 'md' then
          if format == 'html' then
            cmd = { 'quarto', 'render', file, '--to', 'html' }
          elseif format == 'pdf' then
            cmd = { 'quarto', 'render', file, '--to', 'pdf' }
          else
            vim.notify('Unsupported export format: ' .. format, vim.log.levels.ERROR)
            return
          end
        else
          vim.notify('Export not supported for .' .. ext, vim.log.levels.WARN)
          return
        end

        vim.notify('Exporting to ' .. format .. '...', vim.log.levels.INFO)
        vim.system(cmd, { text = true }, function(result)
          vim.schedule(function()
            if result.code == 0 then
              vim.notify('Exported to ' .. format .. ' successfully', vim.log.levels.INFO)
            else
              vim.notify('Export failed:\n' .. (result.stderr or result.stdout or 'unknown error'), vim.log.levels.ERROR)
            end
          end)
        end)
      end

      vim.api.nvim_create_user_command('NotebookExportHtml', function()
        export_current_file 'html'
      end, {})

      vim.api.nvim_create_user_command('NotebookExportPdf', function()
        export_current_file 'pdf'
      end, {})

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

      -- export
      vim.keymap.set('n', '<localleader>mH', ':NotebookExportHtml<CR>', { silent = true, desc = 'Export notebook/document to HTML' })
      vim.keymap.set('n', '<localleader>mP', ':NotebookExportPdf<CR>', { silent = true, desc = 'Export notebook/document to PDF' })
    end,
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
      local runner = require 'quarto.runner'
      vim.keymap.set('n', '<localleader>qc', runner.run_cell, { desc = 'run cell', silent = true })
      vim.keymap.set('n', '<localleader>qa', runner.run_above, { desc = 'run cell and above', silent = true })
      vim.keymap.set('n', '<localleader>qA', runner.run_all, { desc = 'run all cells', silent = true })
      vim.keymap.set('n', '<localleader>ql', runner.run_line, { desc = 'run line', silent = true })
      vim.keymap.set('v', '<localleader>qr', runner.run_range, { desc = 'run visual range', silent = true })
    end,
  },

  {
    'jmbuhr/otter.nvim',
    ft = { 'quarto', 'markdown' },
    opts = {},
  },
  {
    'GCBallesteros/jupytext.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('jupytext').setup {
        custom_language_formatting = {
          python = {
            extension = 'md',
            style = 'markdown',
            force_ft = 'markdown',
          },
          json = {
            extension = 'md',
            style = 'markdown',
            force_ft = 'markdown',
          },
        },
      }
    end,
  },
}
