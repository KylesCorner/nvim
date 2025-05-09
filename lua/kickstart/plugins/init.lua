-- init.lua
-- Author: Kyle Krstulich
-- Date: 2025-05-08

return {
  require 'kickstart.plugins.lsp',
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
  require 'kickstart.plugins.autocompletion',
  require 'kickstart.plugins.autoformat',
  require 'kickstart.plugins.telescope',
  require 'kickstart.plugins.treesitter',
  require 'kickstart.plugins.colorscheme',
}
