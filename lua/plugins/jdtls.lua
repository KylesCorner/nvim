local function basename(path)
  return path:match '([^/]+)$' or path
end

local function numeric_tokens(s)
  local out = {}
  for n in s:gmatch '%d+' do
    out[#out + 1] = tonumber(n)
  end
  return out
end

local function version_gt(a, b)
  local ta = numeric_tokens(basename(a))
  local tb = numeric_tokens(basename(b))
  local n = math.max(#ta, #tb)

  for i = 1, n do
    local va = ta[i] or 0
    local vb = tb[i] or 0
    if va ~= vb then
      return va > vb
    end
  end

  return a > b
end

local function newest_match(pattern)
  local matches = vim.fn.glob(pattern, false, true)

  if not matches or vim.tbl_isempty(matches) then
    return nil
  end

  table.sort(matches, version_gt)
  return matches[1]
end

local function fail(msg)
  vim.notify(msg, vim.log.levels.ERROR)
  return nil
end

local jdtls_dir = newest_match(vim.fn.expand '~/opt/jdt-language-server-*')
if not jdtls_dir then
  return fail 'Could not find any jdt-language-server-* directory under ~/opt'
end

local path_to_jdtls = jdtls_dir .. '/bin/jdtls'
if vim.fn.executable(path_to_jdtls) ~= 1 then
  return fail('Found JDTLS directory but missing executable: ' .. path_to_jdtls)
end

local java_debug_dir = newest_match(vim.fn.expand '~/opt/java-debug-*')
if not java_debug_dir then
  return fail 'Could not find any java-debug-* directory under ~/opt'
end

local debug_jar = newest_match(java_debug_dir .. '/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar')
if not debug_jar then
  return fail('Could not find java debug plugin jar under: ' .. java_debug_dir)
end

local config = {
  cmd = { path_to_jdtls },
  lazy = true,
  root_dir = require('jdtls.setup').find_root { 'gradlew', '.git', 'mvnw', 'pom.xml', 'build.gradle' },
  settings = {
    java = {
      implementationsCodeLens = { enabled = true },
      imports = {
        gradle = {
          enabled = true,
          wrapper = {
            enabled = true,
            checksums = {
              {
                sha256 = '81a82aaea5abcc8ff68b3dfcb58b3c3c429378efd98e7433460610fecd7ae45f',
                allowed = true,
              },
            },
          },
        },
      },
    },
  },
  init_options = {
    bundles = { debug_jar },
  },
}

config.on_attach = function(client, buffer)
  require('jdtls').setup_dap { hotcodereplace = 'auto' }
end

require('jdtls').start_or_attach(config)
