local specs = {
  {
    'milanglacier/minuet-ai.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('minuet').setup {
        provider = 'openai',
        provider_options = {
          openai = {
            model = 'gpt-5.4-nano',
            api_key = 'OPENAI_API_KEY',
            optional = {
              max_completion_tokens = 128,
              reasoning_effort = 'none',
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = { 'lua', 'python', 'cpp', 'c', 'cs' },
          keymap = {
            accept = '<A-A>',
            accept_line = '<A-a>',
            accept_n_lines = '<A-z>',
            prev = '<A-[>',
            next = '<A-]>',
            dismiss = '<A-e>',
          },
        },
      }
    end,
  },
  { 'nvim-lua/plenary.nvim' },
  { 'hrsh7th/nvim-cmp' },
  { 'Saghen/blink.cmp' },
}

return specs
