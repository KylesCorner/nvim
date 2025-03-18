local path_to_jdtls = vim.fn.expand '~/.local/share/nvim/mason/bin/jdtls'
local path_to_debug = vim.fn.expand '~/Other Software/java-debug-0.53.1/com.microsoft.java.debug.plugin/target/'

local config = {
  cmd = { path_to_jdtls },
  init_options = {
    bundles = {
      vim.fn.glob(path_to_debug .. 'com.microsoft.java.debug.plugin-0.53.1.jar', 1), -- debug jar file
    },
  },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
}
config['on_attach'] = function(client, buffer)
  require('jdtls').setup_dap { hotcodereplace = 'auto' }
end

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
