local M = {}
local models = require "mogra.toolchain.models"

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
    ["aarch64-apple-darwin"] = true,
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

-- Read a tool version from toolchain-versions.json in the config directory
function M.read_toolchain_version(tool)
  local file = io.open(vim.fn.stdpath("config") .. "/toolchain-versions.json", "r")
  if not file then
    error("Could not open toolchain-versions.json for reading version for " .. tool)
  end
  local content = file:read("*a")
  file:close()
  local ok, versions = pcall(vim.fn.json_decode, content)
  if not ok or not versions or not versions[tool] then
    error("Could not parse version for " .. tool .. " from toolchain-versions.json")
  end
  return versions[tool]
end

-- Append a line to a file only if it does not already exist
function M.append_line_if_missing(filepath, line)
  local file = io.open(filepath, "r")
  if file then
    for l in file:lines() do
      if l == line then
        file:close()
        return -- Line already exists
      end
    end
    file:close()
  end
  -- Append the line
  file = io.open(filepath, "a")
  if file then
    file:write(line .. "\n")
    file:close()
  else
    error("Could not open " .. filepath .. " for appending")
  end
end

return M
