local M = {}

local helpers = require("mogra.toolchain.helpers")

M.name = "Go"
M.description = "Go programming language and tools"

function M.is_installed()
  return helpers.command_exists("go")
end

function M.install()
  if M.is_installed() then
    vim.notify("Go is already installed", vim.log.levels.INFO)
    return true
  end

  vim.notify("Installing Go...", vim.log.levels.INFO)
  local go_version = "1.22.1"  -- Latest stable as of March 2024
  local download_url = "https://go.dev/dl/go" .. go_version .. ".darwin-amd64.tar.gz"
  local install_dir = os.getenv("HOME") .. "/.local/go"

  -- Create installation directory
  os.execute("mkdir -p " .. install_dir)

  -- Download and install Go
  os.execute("curl -L -O " .. download_url)
  os.execute("rm -rf " .. install_dir .. "/go")
  os.execute("tar -C " .. install_dir .. " -xzf go" .. go_version .. ".darwin-amd64.tar.gz")
  os.execute("rm go" .. go_version .. ".darwin-amd64.tar.gz")

  -- Setup environment variables
  local shell_rc = os.getenv("HOME") .. "/.zshrc"
  local env_vars = {
    "export GOROOT=" .. install_dir .. "/go",
    "export GOPATH=$HOME/go",
    "export PATH=$PATH:$GOROOT/bin:$GOPATH/bin"
  }

  for _, var in ipairs(env_vars) do
    os.execute("echo '" .. var .. "' >> " .. shell_rc)
  end

  vim.notify("Go installation complete! Please run 'source " .. shell_rc .. "' to update your environment", vim.log.levels.SUCCESS)
end

function M.update()
  if not M.is_installed() then
    vim.notify("Go is not installed. Please install it first.", vim.log.levels.WARN)
    return
  end

  vim.notify("Updating Go tools...", vim.log.levels.INFO)
  os.execute("go install -v golang.org/x/tools/gopls@latest")
  os.execute("go install -v github.com/go-delve/delve/cmd/dlv@latest")
  vim.notify("Go tools update complete!", vim.log.levels.SUCCESS)
end

return M
