--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

local uv = vim.uv or vim.loop

local check_version = function()
  local verstr = tostring(vim.version())
  if not vim.version.ge then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim.version.ge(vim.version(), '0.10-dev') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local has_exec = function(exe)
  return vim.fn.executable(exe) == 1
end

local run_ok = function(cmd)
  vim.fn.system(cmd)
  return vim.v.shell_error == 0
end

local first_existing_path = function(paths)
  for _, path in ipairs(paths) do
    if uv.fs_stat(path) then
      return path
    end
  end
  return nil
end

local detect_package_manager = function()
  if has_exec 'pacman' then
    return 'pacman'
  elseif has_exec 'dpkg-query' or has_exec 'apt-get' then
    return 'apt'
  elseif has_exec 'dnf' or has_exec 'rpm' then
    return 'dnf'
  end
  return nil
end

local check_package_installed = function(pm, pkg)
  local pkg_escaped = vim.fn.shellescape(pkg)

  if pm == 'pacman' then
    return run_ok('pacman -Q ' .. pkg_escaped .. ' >/dev/null 2>&1')
  elseif pm == 'apt' then
    local out = vim.fn.system("dpkg-query -W -f='${Status}' " .. pkg_escaped .. ' 2>/dev/null')
    return vim.v.shell_error == 0 and out:match 'install ok installed' ~= nil
  elseif pm == 'dnf' then
    return run_ok('rpm -q ' .. pkg_escaped .. ' >/dev/null 2>&1')
  end

  return false
end

local package_hint = function(pm, pkg)
  if not pm then
    return nil
  end

  if pm == 'pacman' then
    return 'Install with: sudo pacman -S ' .. pkg
  elseif pm == 'apt' then
    return 'Install with: sudo apt-get install ' .. pkg
  elseif pm == 'dnf' then
    return 'Install with: sudo dnf install ' .. pkg
  end

  return nil
end

local check_executable = function(exe, opts)
  opts = opts or {}

  if has_exec(exe) then
    vim.health.ok(string.format("Found executable: '%s'", exe))
    return
  end

  local advice = {}
  if opts.reason then
    table.insert(advice, opts.reason)
  end
  if opts.install_hint then
    table.insert(advice, opts.install_hint)
  end

  vim.health.warn(string.format("Could not find executable: '%s'", exe), advice)
end

local check_package = function(pm, pkg, opts)
  opts = opts or {}

  if not pm then
    vim.health.info(string.format("Skipping package-db check for '%s' (no supported package manager detected)", pkg))
    return
  end

  if check_package_installed(pm, pkg) then
    vim.health.ok(string.format("Found package: '%s'", pkg))
    return
  end

  local advice = {}
  if opts.reason then
    table.insert(advice, opts.reason)
  end

  local hint = package_hint(pm, pkg)
  if hint then
    table.insert(advice, hint)
  end

  vim.health.warn(string.format("Could not find package: '%s'", pkg), advice)
end

local check_basic_external_reqs = function()
  for _, exe in ipairs { 'git', 'make', 'unzip', 'rg' } do
    if has_exec(exe) then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end
end

local check_latex_external_reqs = function()
  local pm = detect_package_manager()

  vim.health.start 'LaTeX / VimTeX requirements'

  if pm then
    vim.health.info('Detected package manager: ' .. pm)
  else
    vim.health.info 'Could not detect supported package manager; using runtime checks only'
  end

  -- Package-level checks
  if pm == 'pacman' then
    check_package(pm, 'zathura', { reason = 'Needed for VimTeX PDF viewing.' })
    check_package(pm, 'zathura-pdf-mupdf', { reason = 'Needed so Zathura can actually open PDF files.' })
    check_package(pm, 'xdotool', { reason = 'Needed for VimTeX Zathura integration on X11.' })
    check_package(pm, 'biber', { reason = 'Needed for bibliography builds that use biber.' })
    check_package(pm, 'tree-sitter-cli', { reason = 'Provides the `tree-sitter` executable used by Treesitter tooling.' })
  elseif pm == 'apt' then
    check_package(pm, 'zathura', { reason = 'Needed for VimTeX PDF viewing.' })
    check_package(pm, 'zathura-pdf-poppler', { reason = 'Needed so Zathura can actually open PDF files.' })
    check_package(pm, 'xdotool', { reason = 'Needed for VimTeX Zathura integration on X11.' })
    check_package(pm, 'biber', { reason = 'Needed for bibliography builds that use biber.' })
    check_package(pm, 'tree-sitter-cli', { reason = 'Provides the `tree-sitter` executable used by Treesitter tooling.' })
  elseif pm == 'dnf' then
    check_package(pm, 'zathura', { reason = 'Needed for VimTeX PDF viewing.' })
    check_package(pm, 'zathura-pdf-poppler', { reason = 'Needed so Zathura can actually open PDF files.' })
    check_package(pm, 'xdotool', { reason = 'Needed for VimTeX Zathura integration on X11.' })
    check_package(pm, 'biber', { reason = 'Needed for bibliography builds that use biber.' })
    check_package(pm, 'tree-sitter-cli', { reason = 'Provides the `tree-sitter` executable used by Treesitter tooling.' })
  end

  -- Executable/runtime checks
  check_executable('zathura', {
    reason = 'Needed for VimTeX PDF viewing.',
    install_hint = package_hint(pm, 'zathura'),
  })

  check_executable('xdotool', {
    reason = 'Needed for VimTeX Zathura integration on X11.',
    install_hint = package_hint(pm, 'xdotool'),
  })

  check_executable('biber', {
    reason = 'Needed for bibliography builds that use biber.',
    install_hint = package_hint(pm, 'biber'),
  })

  check_executable('tree-sitter', {
    reason = 'Needed for Treesitter CLI operations.',
    install_hint = package_hint(pm, 'tree-sitter-cli'),
  })

  -- Zathura PDF backend check
  local zathura_backend = first_existing_path {
    '/usr/lib/zathura/libpdf-mupdf.so',
    '/usr/lib/zathura/libpdf-poppler.so',
    '/usr/local/lib/zathura/libpdf-mupdf.so',
    '/usr/local/lib/zathura/libpdf-poppler.so',
  }

  if zathura_backend then
    vim.health.ok('Found Zathura PDF backend: ' .. zathura_backend)
  else
    local advice = {
      'Zathura may be installed, but PDF viewing will still fail without a PDF backend.',
    }

    if pm == 'pacman' then
      table.insert(advice, 'Install one of: zathura-pdf-mupdf or zathura-pdf-poppler')
    elseif pm == 'apt' or pm == 'dnf' then
      table.insert(advice, 'Install: zathura-pdf-poppler')
    end

    vim.health.warn('Could not detect a Zathura PDF backend', advice)
  end
end

local expand = function(path)
  return vim.fn.expand(path)
end

local path_exists = function(path)
  return uv.fs_stat(path) ~= nil
end

local glob_exists = function(pattern)
  return vim.fn.empty(vim.fn.glob(pattern)) == 0
end

local check_path = function(label, path, opts)
  opts = opts or {}
  local expanded = expand(path)

  if path_exists(expanded) then
    vim.health.ok(string.format("Found %s: '%s'", label, expanded))
    return
  end

  local advice = { 'Expected path: ' .. expanded }

  if opts.reason then
    table.insert(advice, opts.reason)
  end
  if opts.download then
    table.insert(advice, 'Download: ' .. opts.download)
  end
  if opts.note then
    table.insert(advice, opts.note)
  end

  vim.health.warn(string.format('Could not find %s', label), advice)
end

local check_glob = function(label, pattern, opts)
  opts = opts or {}
  local expanded = expand(pattern)

  if glob_exists(expanded) then
    vim.health.ok(string.format("Found %s matching: '%s'", label, expanded))
    return
  end

  local advice = { 'Expected match: ' .. expanded }

  if opts.reason then
    table.insert(advice, opts.reason)
  end
  if opts.download then
    table.insert(advice, 'Download: ' .. opts.download)
  end
  if opts.note then
    table.insert(advice, opts.note)
  end

  vim.health.warn(string.format('Could not find %s', label), advice)
end

local check_java_external_reqs = function()
  vim.health.start 'Java requirements'

  local jdtls_download = 'https://download.eclipse.org/jdtls/milestones/'
  local java_debug_download = 'https://github.com/microsoft/vscode-java-debug/releases'

  -- Basic Java toolchain
  check_executable('java', {
    reason = 'Required to run jdtls. Eclipse JDT LS requires Java 21 or newer.',
  })

  check_executable('javac', {
    reason = 'Strongly recommended so Neovim Java tooling can use a full JDK, not only a JRE.',
  })

  check_executable('mvn', {
    reason = 'Needed for Maven projects and for building java-debug from source.',
  })

  check_executable('gradle', {
    reason = 'Needed for Gradle projects.',
  })

  -- Your pinned jdtls install
  check_path('jdtls launcher script', '~/opt/jdt-language-server-1.46.0-202502271940/bin/jdtls', {
    reason = 'This is the exact path configured in ftplugin/java.lua.',
    download = jdtls_download,
    note = 'If you upgrade jdtls, update ftplugin/java.lua to match the new extracted folder name.',
  })

  -- Your pinned java-debug build directory
  check_path('java-debug target directory', '~/opt/java-debug-0.53.1/com.microsoft.java.debug.plugin/target/', {
    reason = 'This is the exact path configured in ftplugin/java.lua.',
    download = java_debug_download,
    note = 'If you download source instead of a prebuilt asset, build it and keep the generated target directory.',
  })

  -- Actual debug bundle jar inside the pinned target directory
  check_glob('java-debug plugin jar', '~/opt/java-debug-0.53.1/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', {
    reason = 'nvim-jdtls needs the built debug plugin jar bundle.',
    download = java_debug_download,
    note = 'If missing, build java-debug from source or switch your config to point at a downloaded extension/server artifact.',
  })
end

return {
  check = function()
    vim.health.start 'kickstart.nvim'

    vim.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

    check_version()
    check_basic_external_reqs()
    check_latex_external_reqs()
    check_java_external_reqs()
  end,
}
