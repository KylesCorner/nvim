-- r.lua
-- Author: Kyle Krstulich
-- Date: 2025-05-08
return {
  {
    'R-nvim/R.nvim',
    -- Only required if you also set defaults.lazy = true
    lazy = false,
    -- R.nvim is still young and we may make some breaking changes from time
    -- to time (but also bug fixes all the time). If configuration stability
    -- is a high priority for you, pin to the latest minor version, but unpin
    -- it and try the latest version before reporting an issue:
    -- version = "~0.1.0"
    ft = { 'r', 'rmd', 'quarto' },
    config = function()
      -- Create a table with the options to be passed to setup()
      ---@type RConfigUserOpts

      local opts = {
        user_maps_only = true,
        hook = {
          on_filetype = function()
            -- R.nvim custom keybindings (only active when filetype is R or Rmd)
            -- Assumes `user_maps_only = true` is set

            -- Leader key groups:
            -- <localleader>c — for sending code
            -- <localleader>k — for knitting, quarto, and export
            -- <localleader>e — for edit/view/data utilities
            -- <localleader>r - for r interpreter commands

            -- === <localleader>r - for r interpreter commands ===
            vim.api.nvim_buf_set_keymap(
              0,
              'n',
              '<localleader>rcs',
              '<Plug>RCustomStart',
              { noremap = true, silent = true, desc = 'Ask user to enter parameters to start R' }
            )
            vim.api.nvim_buf_set_keymap(
              0,
              'n',
              '<localleader>rs',
              '<Plug>RStart',
              { noremap = true, silent = true, desc = 'Start R with default configuration or reopen terminal window' }
            )
            vim.api.nvim_buf_set_keymap(
              0,
              'n',
              '<localleader>rsc',
              '<Plug>RSaveClose',
              { noremap = true, silent = true, desc = 'Quit R, saving the workspace' }
            )
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>rp', '<Plug>RPackages', { noremap = true, silent = true, desc = 'Install missing package' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>rc', '<Plug>RClose', { noremap = true, silent = true, desc = 'Send to R: quit(save = no)' })

            -- === <localleader>c: Sending Code ===
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>cl', '<Plug>RSendLine', { noremap = true, silent = true, desc = 'Send current line to R' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>cf', '<Plug>RSendCurrentFun', { noremap = true, silent = true, desc = 'Send current function' })
            vim.api.nvim_buf_set_keymap(0, 'v', '<localleader>cs', '<Plug>RSendSelection', { noremap = true, silent = true, desc = 'Send visual selection' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>ca', '<Plug>RSendAboveLines', { noremap = true, silent = true, desc = 'Send lines above cursor' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>cp', '<Plug>RSendParagraph', { noremap = true, silent = true, desc = 'Send paragraph' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>cc', '<Plug>RSendChunk', { noremap = true, silent = true, desc = 'Send current chunk' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>cfh', '<Plug>RSendChunkFH', { noremap = true, silent = true, desc = 'Send all chunks to here' })
            vim.api.nvim_buf_set_keymap(
              0,
              'n',
              '<localleader>cfn',
              '<Plug>RDSendCurrentFun',
              { noremap = true, silent = true, desc = 'Send current fun & move to end' }
            )
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>cm', '<Plug>RSendMotion', { noremap = true, silent = true, desc = 'Send lines via motion' })
            vim.api.nvim_buf_set_keymap(
              0,
              'n',
              '<localleader>cln',
              '<Plug>RSendLAndOpenNewOne',
              { noremap = true, silent = true, desc = 'Send line & open new one' }
            )

            -- === <localleader>k: Knit / Export ===
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>kk', '<Plug>RKnit', { noremap = true, silent = true, desc = 'Knit document' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>kp', '<Plug>RMakePDF', { noremap = true, silent = true, desc = 'Make PDF' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>kh', '<Plug>RMakeHTML', { noremap = true, silent = true, desc = 'Make HTML' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>kw', '<Plug>RMakeWord', { noremap = true, silent = true, desc = 'Make Word doc' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>kq', '<Plug>RQuartoRender', { noremap = true, silent = true, desc = 'Render with Quarto' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>kQ', '<Plug>RQuartoPreview', { noremap = true, silent = true, desc = 'Preview with Quarto' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>ks', '<Plug>RQuartoStop', { noremap = true, silent = true, desc = 'Stop Quarto preview' })

            -- === <localleader>e: Edit / Utilities ===
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>ep', '<Plug>RInsertPipe', { noremap = true, silent = true, desc = 'Insert pipe operator' })
            vim.api.nvim_buf_set_keymap(
              0,
              'i',
              '<localleader>ea',
              '<Plug>RInsertAssign',
              { noremap = true, silent = true, desc = 'Insert assignment operator' }
            )
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>ev', '<Plug>RViewDF', { noremap = true, silent = true, desc = 'View data.frame or matrix' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>ex', '<Plug>RShowEx', { noremap = true, silent = true, desc = 'Show examples for function' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>ed', '<Plug>RDputObj', { noremap = true, silent = true, desc = 'dput current object' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>es', '<Plug>RSeparatePath', { noremap = true, silent = true, desc = 'Split path/url' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>ef', '<Plug>RFormatSubsetting', { noremap = true, silent = true, desc = 'Format $ to [[' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>en', '<Plug>RFormatNumbers', { noremap = true, silent = true, desc = 'Add L to numbers' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>eo', '<Plug>ROBToggle', { noremap = true, silent = true, desc = 'Toggle Object Browser' })
            vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>ec', '<Plug>RClearAll', { noremap = true, silent = true, desc = 'Clear R environment' })

            -- Optional: Bind <Enter> to sending line/selection
            vim.api.nvim_buf_set_keymap(0, 'n', '<Enter>', '<Plug>RDSendLine', { noremap = true, silent = true, desc = 'Send line' })
            vim.api.nvim_buf_set_keymap(0, 'v', '<Enter>', '<Plug>RSendSelection', { noremap = true, silent = true, desc = 'Send selection' })
          end,
        },
        R_args = { '--quiet', '--no-save' },
        min_editor_width = 72,
        rconsole_width = 78,
        objbr_mappings = { -- Object browser keymap
          c = 'class', -- Call R functions
          ['<localleader>gg'] = 'head({object}, n = 15)', -- Use {object} notation to write arbitrary R code.
          v = function()
            -- Run lua functions
            require('r.browser').toggle_view()
          end,
        },
        disable_cmds = {
          'RClearConsole',
          'RCustomStart',
          'RSPlot',
          'RSaveClose',
        },
      }
      -- Check if the environment variable "R_AUTO_START" exists.
      -- If using fish shell, you could put in your config.fish:
      -- alias r "R_AUTO_START=true nvim"
      if vim.env.R_AUTO_START == 'true' then
        opts.auto_start = 'on startup'
        opts.objbr_auto_start = true
      end
      require('r').setup(opts)
    end,
  },
  {
    'R-nvim/cmp-r',
    {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      config = function()
        require('cmp').setup { sources = { { name = 'cmp_r' } } }
        require('cmp_r').setup {}
      end,
    },
  },
}
