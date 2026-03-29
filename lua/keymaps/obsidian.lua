-- Map under <localleader>o
local keymap = vim.keymap.set

-- Normal mode mappings with descriptions
keymap('n', '<localleader>oo', ':ObsidianOpen<CR>', { noremap = true, silent = true, desc = 'Open current note' })
keymap('n', '<localleader>onn', ':ObsidianNew<CR>', { noremap = true, silent = true, desc = 'Create new note' })
keymap('n', '<localleader>oq', ':ObsidianQuickSwitch<CR>', { noremap = true, silent = true, desc = 'Quick switch' })
keymap('n', '<localleader>ol', ':ObsidianFollowLink<CR>', { noremap = true, silent = true, desc = 'Follow link' })
keymap('n', '<localleader>ob', ':ObsidianBacklinks<CR>', { noremap = true, silent = true, desc = 'Show backlinks' })
keymap('n', '<localleader>otl', ':ObsidianTags<CR>', { noremap = true, silent = true, desc = 'Show tags' })
keymap('n', '<localleader>od', ':ObsidianToday<CR>', { noremap = true, silent = true, desc = 'Go to today' })
keymap('n', '<localleader>oy', ':ObsidianYesterday<CR>', { noremap = true, silent = true, desc = 'Go to yesterday' })
keymap('n', '<localleader>om', ':ObsidianTomorrow<CR>', { noremap = true, silent = true, desc = 'Go to tomorrow' })
keymap('n', '<localleader>oa', ':ObsidianDailies<CR>', { noremap = true, silent = true, desc = 'Open dailies' })
keymap('n', '<localleader>op', ':ObsidianPasteImg<CR>', { noremap = true, silent = true, desc = 'Paste image' })
keymap('n', '<localleader>or', ':ObsidianRename<CR>', { noremap = true, silent = true, desc = 'Rename note' })
keymap('n', '<localleader>ox', ':ObsidianTOC<CR>', { noremap = true, silent = true, desc = 'Table of contents' })
keymap('n', '<localleader>os', ':ObsidianSearch<CR>', { noremap = true, silent = true, desc = 'Search notes' })
keymap('n', '<localleader>otm', ':ObsidianTemplate<CR>', { noremap = true, silent = true, desc = 'Insert template' })
keymap('n', '<localleader>ow', ':ObsidianWorkspace<CR>', { noremap = true, silent = true, desc = 'Switch workspace' })
keymap('n', '<localleader>ol', ':ObsidianLinks<CR>', { noremap = true, silent = true, desc = 'Show links' })
keymap('n', '<localleader>oc', ':ObsidianToggleCheckbox<CR>', { noremap = true, silent = true, desc = 'Toggle checkbox' })
keymap('n', '<localleader>ont', ':ObsidianNewFromTemplate<CR>', { noremap = true, silent = true, desc = 'New from template' })

-- Visual mode mappings with descriptions
keymap('v', '<localleader>ol', ':ObsidianLink<CR>', { noremap = true, silent = true, desc = 'Link selection' })
keymap('v', '<localleader>oln', ':ObsidianLinkNew<CR>', { noremap = true, silent = true, desc = 'Link to new note' })
keymap('v', '<localleader>oe', ':ObsidianExtractNote<CR>', { noremap = true, silent = true, desc = 'Extract note' })

return {}
