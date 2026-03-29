local function map(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend('force', {
    buffer = true,
    silent = true,
    desc = desc,
  }, opts or {})

  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Main VimTeX command-style mappings
map('n', '<localleader>li', '<cmd>VimtexInfo<CR>', 'Project info')
map('n', '<localleader>lI', '<cmd>VimtexInfo!<CR>', 'All project info')

map('n', '<localleader>lt', '<cmd>VimtexTocOpen<CR>', 'Open table of contents')
map('n', '<localleader>lT', '<cmd>VimtexTocToggle<CR>', 'Toggle table of contents')

map('n', '<localleader>lq', '<cmd>VimtexLog<CR>', 'Open VimTeX log')
map('n', '<localleader>lv', '<cmd>VimtexView<CR>', 'Open PDF / forward search')

-- Reverse search is a VimTeX plug mapping, not a normal Ex command
map('n', '<localleader>lr', '<Plug>(vimtex-reverse-search)', 'Reverse search', { remap = true })

map('n', '<localleader>ll', '<cmd>VimtexCompile<CR>', 'Compile / toggle compiler')
map({ 'n', 'x' }, '<localleader>lL', '<Plug>(vimtex-compile-selected)', 'Compile selection', { remap = true })
map('n', '<localleader>lS', '<cmd>VimtexCompileSS<CR>', 'Single-shot compile')

map('n', '<localleader>lk', '<cmd>VimtexStop<CR>', 'Stop compiler')
map('n', '<localleader>lK', '<cmd>VimtexStopAll<CR>', 'Stop all compilers')

map('n', '<localleader>le', '<cmd>VimtexErrors<CR>', 'Show errors / quickfix')
map('n', '<localleader>lo', '<cmd>VimtexCompileOutput<CR>', 'Open compiler output')

map('n', '<localleader>lg', '<cmd>VimtexStatus<CR>', 'Compiler status')
map('n', '<localleader>lG', '<cmd>VimtexStatus!<CR>', 'All compiler statuses')

map('n', '<localleader>lc', '<cmd>VimtexClean<CR>', 'Clean aux files')
map('n', '<localleader>lC', '<cmd>VimtexClean!<CR>', 'Clean aux + output files')

map('n', '<localleader>lm', '<cmd>VimtexImapsList<CR>', 'List insert-mode mappings')

map('n', '<localleader>lx', '<cmd>VimtexReload<CR>', 'Reload VimTeX')
map('n', '<localleader>lX', '<cmd>VimtexReloadState<CR>', 'Reload project state')

map('n', '<localleader>ls', '<cmd>VimtexToggleMain<CR>', 'Toggle main/local file')
map('n', '<localleader>la', '<cmd>VimtexContextMenu<CR>', 'Context menu')

-- Useful VimTeX commands that do not have default <localleader>l bindings
map('n', '<localleader>lf', '<cmd>VimtexRefreshFolds<CR>', 'Refresh folds')

map('n', '<localleader>lw', '<cmd>VimtexCountWords<CR>', 'Count words')
map('n', '<localleader>lW', '<cmd>VimtexCountWords!<CR>', 'Count words by file')
map('n', '<localleader>ln', '<cmd>VimtexCountLetters<CR>', 'Count letters')
map('n', '<localleader>lN', '<cmd>VimtexCountLetters!<CR>', 'Count letters by file')

-- Default VimTeX docs mapping
map('n', 'K', '<cmd>VimtexDocPackage<CR>', 'Open package documentation')
