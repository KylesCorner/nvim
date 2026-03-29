-- init.lua
-- Author: Kyle Krstulich
-- Date: 2025-05-08

return {
  require 'core.lsp',
  require 'core.debug',
  require 'core.indent_line',
  -- require 'core.lint',
  require 'core.autopairs',
  require 'core.neo-tree',
  require 'core.gitsigns', -- adds gitsigns recommend keymaps
  require 'core.autocompletion',
  require 'core.autoformat',
  require 'core.telescope',
  require 'core.treesitter',
  require 'core.colorscheme',
  -- require 'core.which-key',
  require 'core.todo-comments',
  require 'core.mini',
}
