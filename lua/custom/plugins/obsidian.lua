-- local opts = { noremap = true, silent = true }
--
-- -- Map under <localleader>o
-- local keymap = vim.keymap.set
--
-- -- Obsidian keybindings
-- vim.keymap.set('n', '<localleader>oo', ':ObsidianOpen<CR>', opts)
-- keymap('n', '<localleader>on', ':ObsidianNew<CR>', opts)
-- keymap('n', '<localleader>oq', ':ObsidianQuickSwitch<CR>', opts)
-- keymap('n', '<localleader>ol', ':ObsidianFollowLink<CR>', opts)
-- keymap('n', '<localleader>ob', ':ObsidianBacklinks<CR>', opts)
-- keymap('n', '<localleader>ot', ':ObsidianTags<CR>', opts)
-- keymap('n', '<localleader>od', ':ObsidianToday<CR>', opts)
-- keymap('n', '<localleader>oy', ':ObsidianYesterday<CR>', opts)
-- keymap('n', '<localleader>om', ':ObsidianTomorrow<CR>', opts)
-- keymap('n', '<localleader>oa', ':ObsidianDailies<CR>', opts)
-- keymap('n', '<localleader>op', ':ObsidianPasteImg<CR>', opts)
-- keymap('n', '<localleader>or', ':ObsidianRename<CR>', opts)
-- keymap('n', '<localleader>ox', ':ObsidianTOC<CR>', opts)
-- keymap('n', '<localleader>os', ':ObsidianSearch<CR>', opts)
-- keymap('n', '<localleader>otm', ':ObsidianTemplate<CR>', opts)
-- keymap('n', '<localleader>ow', ':ObsidianWorkspace<CR>', opts)
-- keymap('n', '<localleader>oln', ':ObsidianLinks<CR>', opts)
-- keymap('n', '<localleader>oc', ':ObsidianToggleCheckbox<CR>', opts)
-- keymap('n', '<localleader>oft', ':ObsidianNewFromTemplate<CR>', opts)
--
-- -- Visual mode mappings
-- keymap('v', '<localleader>ol', ':ObsidianLink<CR>', opts)
-- keymap('v', '<localleader>oln', ':ObsidianLinkNew<CR>', opts)
-- keymap('v', '<localleader>oe', ':ObsidianExtractNote<CR>', opts)

return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    -- 'BufReadPre '
    --   .. vim.fn.expand '~'
    --   .. '/personal/*.md',
    -- 'BufNewFile ' .. vim.fn.expand '~' .. '/personal/*.md',
  },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = 'personal',
        path = '~/Vaults/personal',
      },
      {
        name = 'work',
        path = '~/Vaults/work',
      },
      -- {
      --   name = 'work',
      --   path = '~/Vaults/school',
      -- },
    },

    daily_notes = {
      folder = 'Daily Notes',
      template = 'daily.md',
    },

    templates = {
      folder = 'Templates',
    },

    ui = {
      enable = true,

      bullets = {
        symbols = {}, -- disable rendering
      },

      checkboxes = {
        symbols = {},
      },
    },

    -- Use the text from the link for the new note name
    note_id_func = function(title)
      -- If no title is given (e.g. user just types [[]]), fallback to date-based
      if title ~= nil then
        return title
      else
        return tostring(os.time())
      end
    end,

    -- -- Optional: auto-add .md extension if not included
    -- note_path_func = function(spec)
    --   local filename = spec.id
    --   if not filename:match '%.md$' then
    --     filename = filename .. '.md'
    --   end
    --   return spec.dir / filename

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      -- vim.fn.jobstart { 'open', url } -- Mac OS
      -- vim.fn.jobstart { 'xdg-open', url } -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      vim.ui.open(url) -- need Neovim 0.10.0+
    end,

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
    -- file it will be ignored but you can customize this behavior here.
    ---@param img string
    follow_img_func = function(img)
      -- vim.fn.jobstart { 'qlmanage', '-p', img } -- Mac OS quick look preview
      vim.fn.jobstart { 'xdg-open', url } -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
    end, -- end,
  },
}
