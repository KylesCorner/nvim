return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.cursorword').setup()
      require('mini.starter').setup()

      local statusline = require 'mini.statusline'

      -- Track VimTeX compiler state per buffer
      local vimtex_group = vim.api.nvim_create_augroup('vimtex-statusline', { clear = true })

      vim.api.nvim_create_autocmd('FileType', {
        group = vimtex_group,
        pattern = 'tex',
        callback = function()
          if vim.b.vimtex_compiler_running == nil then
            vim.b.vimtex_compiler_running = false
          end
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        group = vimtex_group,
        pattern = 'VimtexEventCompileStarted',
        callback = function()
          vim.b.vimtex_compiler_running = true
          vim.cmd 'redrawstatus'
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        group = vimtex_group,
        pattern = 'VimtexEventCompileStopped',
        callback = function()
          vim.b.vimtex_compiler_running = false
          vim.cmd 'redrawstatus'
        end,
      })

      local function section_vimtex_compiler(args)
        if vim.bo.filetype ~= 'tex' or statusline.is_truncated(args.trunc_width) then
          return ''
        end

        return vim.b.vimtex_compiler_running and 'TeX RUN' or 'TeX STOP'
      end

      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
            local git = statusline.section_git { trunc_width = 40 }
            local diff = statusline.section_diff { trunc_width = 75 }
            local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
            local lsp = statusline.section_lsp { trunc_width = 75 }
            local tex = section_vimtex_compiler { trunc_width = 100 }
            local filename = statusline.section_filename { trunc_width = 140 }
            local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
            local location = statusline.section_location { trunc_width = 75 }
            local search = statusline.section_searchcount { trunc_width = 75 }

            return statusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp, tex } },
              '%<',
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=',
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            }
          end,
        },
      }

      -- Keep your custom cursor location format
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
