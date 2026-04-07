local M = {}

local AUTHOR_NAME = 'Kyle Krstulich'

local function get_template_dir()
  return vim.fn.stdpath 'config' .. '/templates'
end

local function scan_templates()
  local template_dir = get_template_dir()
  local templates = {}

  if vim.fn.isdirectory(template_dir) == 0 then
    vim.notify("Template directory doesn't exist: " .. template_dir, vim.log.levels.WARN)
    return templates
  end

  local handle = vim.loop.fs_scandir(template_dir)
  if not handle then
    vim.notify('Error scanning template directory: ' .. template_dir, vim.log.levels.ERROR)
    return templates
  end

  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end
    if type == 'file' then
      table.insert(templates, name)
    end
  end

  return templates
end

local function get_candidate_keys()
  local filename = vim.fn.expand '%:t'
  local ext = vim.fn.expand '%:e'
  local filetype = vim.bo.filetype

  local keys = {}

  -- Most specific: exact filename
  if filename ~= '' then
    table.insert(keys, filename)
  end

  -- Common: extension-based templates
  if ext ~= '' then
    table.insert(keys, ext)
  end

  -- Fallback: filetype-based templates
  if filetype ~= '' and filetype ~= ext then
    table.insert(keys, filetype)
  end

  return keys
end

local function get_templates_for_buffer()
  local all_templates = scan_templates()
  local keys = get_candidate_keys()
  local matches = {}

  for _, template in ipairs(all_templates) do
    for _, key in ipairs(keys) do
      if template == key or template:match('%.' .. vim.pesc(key) .. '$') then
        table.insert(matches, template)
        break
      end
    end
  end

  return matches
end

local function insert_template(template_file)
  local fullpath = get_template_dir() .. '/' .. template_file
  local filename = vim.fn.expand '%:t'
  local lines = {}

  for line in io.lines(fullpath) do
    line = line:gsub('__FILENAME__', filename):gsub('__DATE__', os.date '%Y-%m-%d'):gsub('__AUTHOR__', AUTHOR_NAME)
    table.insert(lines, line)
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

function M.prompt_and_insert_template()
  if vim.fn.line '$' > 1 or vim.fn.getline(1) ~= '' then
    return
  end

  local templates = get_templates_for_buffer()

  if #templates == 0 then
    vim.notify('No matching templates found', vim.log.levels.INFO)
    return
  end

  if #templates == 1 then
    insert_template(templates[1])
    return
  end

  vim.ui.select(templates, { prompt = 'Choose a template:' }, function(choice)
    if choice then
      insert_template(choice)
    end
  end)
end

return M
