local function find_pio_root()
  local buf_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  local match = vim.fs.find('platformio.ini', { upward = true, path = buf_dir })[1]
  return match and vim.fs.dirname(match) or nil
end

local function read_pio_envs(root)
  local ini = root .. '/platformio.ini'
  if vim.fn.filereadable(ini) ~= 1 then
    return {}
  end

  local lines = vim.fn.readfile(ini)
  local envs = {}

  for _, line in ipairs(lines) do
    local env = line:match '^%s*%[env:([^%]]+)%]%s*$'
    if env then
      table.insert(envs, env)
    end
  end

  return envs
end

_G.PlatformIOEnvState = _G.PlatformIOEnvState or {}

local function get_selected_env(root)
  if _G.PlatformIOEnvState[root] then
    return _G.PlatformIOEnvState[root]
  end

  local envs = read_pio_envs(root)
  if #envs > 0 then
    _G.PlatformIOEnvState[root] = envs[1]
    return envs[1]
  end

  return nil
end

local function set_selected_env(root, env)
  _G.PlatformIOEnvState[root] = env
end

local function open_term(cmd, cwd, title)
  vim.cmd 'botright 12split'
  vim.cmd 'enew'

  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buflisted = false

  vim.fn.termopen({ 'bash', '-lc', cmd }, {
    cwd = cwd,
    on_exit = function(_, code, _)
      vim.schedule(function()
        if code == 0 then
          vim.notify(title .. ' finished', vim.log.levels.INFO)
        else
          vim.notify(title .. ' failed (' .. code .. ')', vim.log.levels.ERROR)
        end
      end)
    end,
  })

  vim.cmd 'startinsert'
end

local root = find_pio_root()
if not root then
  return
end

local function pio(cmd, title)
  return function()
    local env = get_selected_env(root)
    local full_cmd = 'pio ' .. cmd

    if env and env ~= '' then
      full_cmd = full_cmd .. ' -e ' .. vim.fn.shellescape(env)
    end

    open_term(full_cmd, root, title)
  end
end

vim.keymap.set('n', '<localleader>pe', function()
  local envs = read_pio_envs(root)

  if #envs == 0 then
    vim.notify('No PlatformIO environments found in platformio.ini', vim.log.levels.ERROR)
    return
  end

  vim.ui.select(envs, {
    prompt = 'Select PlatformIO environment',
    format_item = function(item)
      local current = get_selected_env(root)
      if item == current then
        return item .. ' [current]'
      end
      return item
    end,
  }, function(choice)
    if not choice then
      return
    end

    set_selected_env(root, choice)
    vim.notify('PlatformIO env set to: ' .. choice, vim.log.levels.INFO)
  end)
end, {
  buffer = true,
  desc = 'PIO Select Env',
})

vim.keymap.set('n', '<localleader>ps', function()
  local env = get_selected_env(root)
  if env then
    vim.notify('Current PlatformIO env: ' .. env, vim.log.levels.INFO)
  else
    vim.notify('No PlatformIO env selected', vim.log.levels.WARN)
  end
end, {
  buffer = true,
  desc = 'PIO Show Env',
})

vim.keymap.set('n', '<localleader>pb', pio('run', 'PlatformIO build'), {
  buffer = true,
  desc = 'PIO Build',
})

vim.keymap.set('n', '<localleader>pu', pio('run -t upload', 'PlatformIO upload'), {
  buffer = true,
  desc = 'PIO Upload',
})

vim.keymap.set('n', '<localleader>pm', pio('device monitor', 'PlatformIO monitor'), {
  buffer = true,
  desc = 'PIO Monitor',
})

vim.keymap.set('n', '<localleader>pc', pio('run -t clean', 'PlatformIO clean'), {
  buffer = true,
  desc = 'PIO Clean',
})

vim.keymap.set('n', '<localleader>pd', pio('run -t compiledb', 'PlatformIO compiledb'), {
  buffer = true,
  desc = 'PIO Compile DB',
})

vim.keymap.set('n', '<localleader>pt', function()
  vim.notify('PlatformIO root: ' .. root, vim.log.levels.INFO)
end, {
  buffer = true,
  desc = 'PIO Project Root',
})
