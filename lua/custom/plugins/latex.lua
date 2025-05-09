-- latex.lua
-- Author: Kyle Krstulich
-- Date: 2025-05-08
return {
  {
    'lervag/vimtex',
    lazy = false, -- we don't want to lazy load VimTeX
    ft = { 'tex' },
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.tex_flavor = 'latex'
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_quickfix_mode = 0
      vim.o.conceallevel = 1
      vim.g.tex_conceal = 'abdmg'
    end,
  },
}
