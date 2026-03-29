return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[c]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[d]ocument' },
        { '<leader>k', group = 'file [k]nit' },
        { '<leader>s', group = '[s]earch' },
        { '<leader>w', group = '[w]orkspace' },
        { '<leader>t', group = '[t]oggle' },
        { '<leader>h', group = 'Git [h]unk', mode = { 'n', 'v' } },
        { '<localleader>l', group = '[l]atex', mode = { 'n', 'v' } },
        { '<localleader>m', group = '[m]agma', mode = { 'n', 'v' } },
        { '<leader>b', group = 'De[b]uger', mode = { 'n', 'v' } },
        { '<leader>e', group = 'File [e]xplorer' },
        { '<leader>r', group = '[r]ename' },
        { '<localleader>r', group = '[r] actions' },
        { '<localleader>c', group = 'r [c]ode block' },
        { '<localleader>k', group = '[k]nit file' },
        { '<localleader>e', group = '[e]dit utilities' },
        { '<localleader>o', group = '[o]bsidian' },
      },
    },
  },
}
