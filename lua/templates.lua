local M = {}

local AUTHOR_NAME = 'Kyle Krstulich'
-- Get templates matching the current filetype
local function get_templates_for_filetype(filetype)
  -- Get the path to the templates directory
  local template_dir = vim.fn.stdpath 'config' .. '/templates/'
  print(template_dir)

  -- Initialize an empty table to store matching templates
  local templates = {}

  -- Check if the template directory exists
  if vim.fn.isdirectory(template_dir) == 0 then
    print("Template directory doesn't exist: " .. template_dir)
    return templates
  end

  -- Use lua's asynchronous fs_scandir to read files in the directory
  local handle = vim.loop.fs_scandir(template_dir)
  if not handle then
    print('Error scanning template directory: ' .. template_dir)
    return templates
  end

  -- Iterate through the directory's contents
  while true do
    -- Get the next file or directory in the scanned handle
    local name, type = vim.loop.fs_scandir_next(handle)

    -- If no more files, break the loop
    if not name then
      break
    end

    -- Check if it's a file and matches the template pattern for the current filetype
    if type == 'file' and name:match('.*%.' .. filetype .. '$') then
      -- Add the matching template filename to the templates table
      table.insert(templates, name)
    end
  end

  -- Return the list of matching templates
  return templates
end

-- Replace placeholders in the template and insert it into the buffer
local function insert_template(template_file)
  local template_dir = vim.fn.stdpath 'config' .. '/templates'
  local fullpath = template_dir .. '/' .. template_file
  local filename = vim.fn.expand '%:t'
  local lines = {}

  for line in io.lines(fullpath) do
    line = line:gsub('__FILENAME__', filename):gsub('__DATE__', os.date '%Y-%m-%d'):gsub('__AUTHOR__', AUTHOR_NAME)
    table.insert(lines, line)
  end

  -- Insert the template lines into the empty buffer
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

-- Prompt user to choose a template and insert it
function M.prompt_and_insert_template()
  -- Only act on empty buffers (new files)
  if vim.fn.line '$' > 1 then
    return
  end

  local filetype = vim.bo.filetype
  local templates = get_templates_for_filetype(filetype)

  if #templates == 0 then
    print('No ' .. filetype .. ' templates are found.')
    return
  end
  if #templates == 1 then
    insert_template(templates[1])
  else
    vim.ui.select(templates, { prompt = 'Choose a template:' }, function(choice)
      if choice then
        insert_template(choice)
      end
    end)
  end
end

return M
