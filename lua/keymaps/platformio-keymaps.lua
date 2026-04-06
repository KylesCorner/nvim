local pio = require 'plugins.platformio'
local util = require 'utils'

-- if not pio.find_root(0) then
--   return
-- end
if not util.find_pio_root(0) then
  return
end

local function map(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

map('<localleader>pe', function()
  pio.select_env(0)
end, 'PIO Select Env')
map('<localleader>ps', function()
  pio.show_env(0)
end, 'PIO Show Env')
map('<localleader>pb', function()
  pio.build(0)
end, 'PIO Build')
map('<localleader>pu', function()
  pio.upload(0)
end, 'PIO Upload')
map('<localleader>pm', function()
  pio.monitor(0)
end, 'PIO Monitor')
map('<localleader>pc', function()
  pio.clean(0)
end, 'PIO Clean')
map('<localleader>pd', function()
  pio.compiledb(0)
end, 'PIO Compile DB')
map('<localleader>pt', function()
  pio.show_root(0)
end, 'PIO Project Root')
