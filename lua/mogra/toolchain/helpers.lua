local M = {}
local models = require "mogra.toolchain.models"
local repository = require "mogra.toolchain.repository"

-- Run a shell command and return its output
function M.run_command(cmd)
  local handle = io.popen(cmd)
  if handle then
    local result = handle:read "*a"
    handle:close()
    return result
  end
  return nil
end

-- Check if a command exists in PATH
function M.command_exists(cmd)
  local result = M.run_command("command -v " .. cmd)
  return result ~= nil and result ~= ""
end

-- Get latest version from GitHub API
function M.get_latest_github_version(repo)
  return repository.get_latest_version(repo)
end

-- Get latest version and download URL from GitHub API
function M.get_latest_github_release(repo)
  local release_data = repository.get_latest_release(repo)
  if not release_data then
    error("release_data is nil")
  end

  -- Parse the release data into our model
  local release = models.parse_github_release(release_data)

  -- Get system architecture
  local arch, os_name = M.detect_system()
  local system = models.new_system_architecture(arch, os_name)

  -- Find matching asset
  local asset = models.find_matching_asset(release, system)
  local download_url = asset and asset.browser_download_url or nil

  -- Extract version from tag_name
  local version = release.tag_name and release.tag_name:gsub("^v", "") or nil

  return version, download_url
end

-- Detect system architecture and OS
function M.detect_system()
  local arch = nil
  local os_name = nil

  -- Detect architecture
  local arch_result = M.run_command "uname -m 2>&1"
  if not arch_result then
    error("Failed to detect system architecture")
  end

  arch_result = arch_result:gsub("%s+$", "")
  if arch_result == "arm64" or arch_result == "aarch64" then
    arch = "aarch64"
  elseif arch_result == "x86_64" then
    arch = "x86_64"
  else
    error("Unsupported architecture: " .. arch_result)
  end

  -- Detect OS
  local os_result = M.run_command "uname -s 2>&1"
  if not os_result then
    error("Failed to detect operating system")
  end

  os_result = os_result:gsub("%s+$", "")
  if os_result == "Darwin" then
    os_name = "apple-darwin"
  elseif os_result == "Linux" then
    os_name = "unknown-linux-gnu"
  else
    error("Unsupported operating system: " .. os_result)
  end

  return arch, os_name
end

-- Get supported system combinations
function M.get_supported_combinations()
  return {
    ["x86_64-apple-darwin"] = true,
    ["aarch64-apple-darwin"] = true,
    ["x86_64-unknown-linux-gnu"] = true,
    ["aarch64-unknown-linux-gnu"] = true,
  }
end

-- Validate system combination and get fallback if needed
function M.validate_system_combination(arch, os_name)
  local supported = M.get_supported_combinations()
  local system = models.new_system_architecture(arch, os_name)

  if not supported[system.combination] then
    error("Unsupported system combination: " .. system.combination)
  end

  return arch, os_name
end

return M
