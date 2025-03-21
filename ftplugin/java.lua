local path_to_jdtls = '/home/kyle/Other Software/jdt-language-server-1.46.0-202502271940/bin/jdtls'
local path_to_debug = vim.fn.expand '~/Other Software/java-debug-0.53.1/com.microsoft.java.debug.plugin/target/'

local config = {
  cmd = { path_to_jdtls },
  -- root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', '.gitignfore', 'mvnw', 'build.gradle.kts' }, { upward = true })[1]),
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
    bundles = {
      vim.fn.glob(path_to_debug .. 'com.microsoft.java.debug.plugin-0.53.1.jar', 1), -- debug jar file
    },
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
config['on_attach'] = function(client, buffer)
  require('jdtls').setup_dap { hotcodereplace = 'auto' }
end

require('jdtls').start_or_attach(config)
