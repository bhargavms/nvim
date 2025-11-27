local M = {}
local helpers = require "mogra.toolchain.helpers"

M.name = "Kotlin LSP"
M.description = "Kotlin Language Server (kotlin-lsp)"

local install_dir = os.getenv "HOME" .. "/.local/kotlin-lsp"
local home_dir = os.getenv "HOME"
local symlink_path = home_dir .. "/.local/bin/kotlin-ls"

function M.is_installed()
  return vim.fn.executable "kotlin-ls" == 1
end

function M.install()
  if vim.fn.isdirectory(install_dir) == 1 then
    os.execute("rm -rf " .. install_dir)
  end
  os.execute("mkdir -p " .. install_dir)

  -- Get latest release info from GitHub API
  local _, download_url = helpers.get_latest_github_release("Kotlin/kotlin-lsp")
  if not download_url then
    error("Failed to get download URL for Kotlin LSP")
  end

  -- Download and extract the latest release
  os.execute("curl -L " .. download_url .. " -o " .. install_dir .. "/server.zip")
  os.execute("unzip -o " .. install_dir .. "/server.zip -d " .. install_dir)
  os.execute("rm " .. install_dir .. "/server.zip")

  os.execute("chmod +x " .. install_dir .. "/scripts/kotlin-lsp.sh")
  os.execute("ln -s " .. install_dir .. "/scripts/kotlin-lsp.sh " .. symlink_path)
  os.execute("chmod +x " .. symlink_path)
  vim.notify("Kotlin LSP installed!", vim.log.levels.INFO)
end

function M.update()
  -- Check if kotlin-ls is installed
  if not M.is_installed() then
    error("Kotlin LSP is not installed. Please install it using the toolchain.")
  end

  -- Check for latest release
  local latest_version, _ = helpers.get_latest_github_release("Kotlin/kotlin-lsp")
  if not latest_version then
    error("Failed to get latest version information from GitHub")
  end

  -- Clean up existing installation
  if vim.fn.isdirectory(install_dir) == 1 then
    os.execute("rm -rf " .. install_dir)
  end
  if vim.fn.filereadable(symlink_path) == 1 then
    os.execute("rm " .. symlink_path)
  end

  -- Reinstall with latest version
  M.install()
  vim.notify("Kotlin LSP updated to latest version!", vim.log.levels.INFO)
end

return M
