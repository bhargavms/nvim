local M = {}

local helpers = require "mogra.toolchain.helpers"

M.name = "Ripgrep"
M.description = "Fast line-oriented search tool"

-- Get the latest version and download URL from GitHub releases
local function get_latest_release()
  local version, download_url = helpers.get_latest_github_release "BurntSushi/ripgrep"
  if not version or not download_url then
    vim.notify("version or download url wasn't present", vim.log.levels.ERROR)
    return
  end
  return version, download_url
end

function M.is_installed()
  return helpers.command_exists "rg"
end

function M.install()
  vim.notify("Installing Ripgrep...", vim.log.levels.INFO)
  local temp_dir = os.getenv "HOME" .. "/.local/tmp/ripgrep-install"
  local install_dir = os.getenv "HOME" .. "/.local/bin"
  local version, download_url = get_latest_release()

  if not download_url then
    vim.notify("Failed to get download URL for Ripgrep", vim.log.levels.ERROR)
    return
  end

  local arch, os_name = helpers.detect_system()
  arch, os_name = helpers.validate_system_combination(arch, os_name)

  -- Create installation directories
  os.execute("mkdir -p " .. temp_dir)
  os.execute("mkdir -p " .. install_dir)

  -- Download and install ripgrep
  local download_cmd = "cd " .. temp_dir .. " && curl -LO " .. download_url
  local extract_cmd = "cd "
    .. temp_dir
    .. " && tar xzf ripgrep-"
    .. version
    .. "-"
    .. arch
    .. "-"
    .. os_name
    .. ".tar.gz"
  local copy_cmd = "cp "
    .. temp_dir
    .. "/ripgrep-"
    .. version
    .. "-"
    .. arch
    .. "-"
    .. os_name
    .. "/rg "
    .. install_dir
    .. "/rg"

  -- Execute commands with error checking
  local success = os.execute(download_cmd)
  if not success then
    vim.notify("Failed to download Ripgrep", vim.log.levels.ERROR)
    os.execute("rm -rf " .. temp_dir)
    return
  end

  success = os.execute(extract_cmd)
  if not success then
    vim.notify("Failed to extract Ripgrep archive", vim.log.levels.ERROR)
    os.execute("rm -rf " .. temp_dir)
    return
  end

  success = os.execute(copy_cmd)
  if not success then
    vim.notify("Failed to copy Ripgrep binary", vim.log.levels.ERROR)
    os.execute("rm -rf " .. temp_dir)
    return
  end

  -- Make it executable
  os.execute("chmod +x " .. install_dir .. "/rg")

  -- Setup environment variables
  local shell_rc = os.getenv "HOME" .. "/.zshrc"
  local env_var = "export PATH=$PATH:" .. install_dir

  -- Add to PATH if not already present
  if not helpers.command_exists "rg" then
    os.execute("echo '" .. env_var .. "' >> " .. shell_rc)
  end

  -- Clean up
  os.execute("rm -rf " .. temp_dir)

  vim.notify(
    "Ripgrep " .. version ..
		" installation complete! Please run 'source " .. shell_rc .. "' to update your environment",
    vim.log.levels.SUCCESS
  )
end

function M.update()
  if not M.is_installed() then
    vim.notify("Ripgrep is not installed. Please install it first.", vim.log.levels.WARN)
    return
  end

  -- Get current version
  local current_version = "0.0.0"
  local result = helpers.run_command "rg --version 2>&1"
  if result then
    current_version = result:match "ripgrep%s+(%d+%.%d+%.%d+)" or "0.0.0"
  end

  -- Get latest version and download URL
  local latest_version, download_url = get_latest_release()

  if not download_url then
    vim.notify("Failed to get download URL for Ripgrep update", vim.log.levels.ERROR)
    return
  end

  -- Compare versions
  if current_version == latest_version then
    vim.notify("Ripgrep is already at the latest version (" .. latest_version .. ")", vim.log.levels.INFO)
    return
  end

  vim.notify("Updating Ripgrep from " .. current_version .. " to " .. latest_version .. "...", vim.log.levels.INFO)
  local temp_dir = os.getenv "HOME" .. "/.local/tmp/ripgrep-update"
  local install_dir = os.getenv "HOME" .. "/.local/bin"
  local arch, os_name = helpers.detect_system()
  arch, os_name = helpers.validate_system_combination(arch, os_name)

  -- Create temporary directory
  os.execute("mkdir -p " .. temp_dir)

  -- Download and install latest version
  local download_cmd = "cd " .. temp_dir .. " && curl -LO " .. download_url
  local extract_cmd = "cd "
    .. temp_dir
    .. " && tar xzf ripgrep-"
    .. latest_version
    .. "-"
    .. arch
    .. "-"
    .. os_name
    .. ".tar.gz"
  local copy_cmd = "cp "
    .. temp_dir
    .. "/ripgrep-"
    .. latest_version
    .. "-"
    .. arch
    .. "-"
    .. os_name
    .. "/rg "
    .. install_dir
    .. "/rg"

  -- Execute commands with error checking
  local success = os.execute(download_cmd)
  if not success then
    vim.notify("Failed to download Ripgrep update", vim.log.levels.ERROR)
    os.execute("rm -rf " .. temp_dir)
    return
  end

  success = os.execute(extract_cmd)
  if not success then
    vim.notify("Failed to extract Ripgrep update archive", vim.log.levels.ERROR)
    os.execute("rm -rf " .. temp_dir)
    return
  end

  success = os.execute(copy_cmd)
  if not success then
    vim.notify("Failed to copy Ripgrep update binary", vim.log.levels.ERROR)
    os.execute("rm -rf " .. temp_dir)
    return
  end

  -- Make it executable
  os.execute("chmod +x " .. install_dir .. "/rg")

  -- Clean up
  os.execute("rm -rf " .. temp_dir)

  vim.notify("Ripgrep updated to version " .. latest_version .. "!", vim.log.levels.SUCCESS)
end

return M
