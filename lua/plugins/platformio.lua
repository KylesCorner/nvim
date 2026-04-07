local M = {}

local util = require 'utils'

M.state = {}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

function M.find_root(bufnr)
  return util.find_pio_root(bufnr or 0)
end

function M.get_envs(root)
  if not root then
    return {}
  end

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

function M.get_current_env(root)
  if not root then
    return nil
  end

  if M.state[root] then
    return M.state[root]
  end

  local envs = M.get_envs(root)
  if #envs > 0 then
    M.state[root] = envs[1]
    return envs[1]
  end

  return nil
end

function M.set_env(root, env)
  if root and env and env ~= '' then
    M.state[root] = env
  end
end

function M.select_env(bufnr)
  local root = M.find_root(bufnr or 0)
  if not root then
    notify('No platformio.ini found for this buffer', vim.log.levels.ERROR)
    return
  end

  local envs = M.get_envs(root)
  if #envs == 0 then
    notify('No [env:...] sections found in platformio.ini', vim.log.levels.ERROR)
    return
  end

  vim.ui.select(envs, {
    prompt = 'Select PlatformIO environment',
    format_item = function(item)
      local current = M.get_current_env(root)
      if item == current then
        return item .. ' [current]'
      end
      return item
    end,
  }, function(choice)
    if not choice then
      return
    end

    M.set_env(root, choice)
    notify('PlatformIO env set to: ' .. choice)
  end)
end

function M.show_env(bufnr)
  local root = M.find_root(bufnr or 0)
  if not root then
    notify('No platformio.ini found for this buffer', vim.log.levels.ERROR)
    return
  end

  local env = M.get_current_env(root)
  if env then
    notify('Current PlatformIO env: ' .. env)
  else
    notify('No PlatformIO env selected', vim.log.levels.WARN)
  end
end

function M.show_root(bufnr)
  local root = M.find_root(bufnr or 0)
  if root then
    notify('PlatformIO root: ' .. root)
  else
    notify('No platformio.ini found for this buffer', vim.log.levels.ERROR)
  end
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
          notify(title .. ' finished')
        else
          notify(title .. ' failed (' .. code .. ')', vim.log.levels.ERROR)
        end
      end)
    end,
  })

  vim.cmd 'startinsert'
end

local function build_pio_cmd(subcmd, root)
  local env = M.get_current_env(root)
  local cmd = 'pio ' .. subcmd

  if env and env ~= '' then
    cmd = cmd .. ' -e ' .. vim.fn.shellescape(env)
  end

  return cmd
end

function M.run(subcmd, title, bufnr)
  local root = M.find_root(bufnr or 0)
  if not root then
    notify('No platformio.ini found for this buffer', vim.log.levels.ERROR)
    return
  end

  local cmd = build_pio_cmd(subcmd, root)
  open_term(cmd, root, title)
end

function M.build(bufnr)
  M.run('run', 'PlatformIO build', bufnr)
end

function M.upload(bufnr)
  M.run('run -t upload', 'PlatformIO upload', bufnr)
end

function M.monitor(bufnr)
  M.run('device monitor', 'PlatformIO monitor', bufnr)
end

function M.clean(bufnr)
  M.run('run -t clean', 'PlatformIO clean', bufnr)
end

function M.compiledb(bufnr)
  M.run('run -t compiledb', 'PlatformIO compiledb', bufnr)
end

function M.setup_keymaps(bufnr)
  bufnr = bufnr or 0

  if not M.find_root(bufnr) then
    return
  end

  local function map(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
  end

  map('<localleader>pe', function()
    M.select_env(bufnr)
  end, 'PIO Select Env')

  map('<localleader>ps', function()
    M.show_env(bufnr)
  end, 'PIO Show Env')

  map('<localleader>pb', function()
    M.build(bufnr)
  end, 'PIO Build')

  map('<localleader>pu', function()
    M.upload(bufnr)
  end, 'PIO Upload')

  map('<localleader>pm', function()
    M.monitor(bufnr)
  end, 'PIO Monitor')

  map('<localleader>pc', function()
    M.clean(bufnr)
  end, 'PIO Clean')

  map('<localleader>pd', function()
    M.compiledb(bufnr)
  end, 'PIO Compile DB')

  map('<localleader>pt', function()
    M.show_root(bufnr)
  end, 'PIO Project Root')
end

function M.setup()
  local augroup = vim.api.nvim_create_augroup('PlatformIOKeymaps', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    group = augroup,
    callback = function(args)
      M.setup_keymaps(args.buf)
    end,
  })
end

return M
