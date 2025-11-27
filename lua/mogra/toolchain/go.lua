local M = {}

local helpers = require("mogra.toolchain.helpers")

M.name = "Go"
M.description = "Go programming language and tools"

-- Go tools to install via `go install`
-- Format: { binary_name, install_path }
M.tools = {
  { "gopls", "golang.org/x/tools/gopls@latest" },
  { "dlv", "github.com/go-delve/delve/cmd/dlv@latest" },
  { "golangci-lint", "github.com/golangci/golangci-lint/cmd/golangci-lint@latest" },
  { "gonew", "golang.org/x/tools/cmd/gonew@latest" },
  { "go-enum", "github.com/abice/go-enum@latest" },
  { "fillswitch", "github.com/davidrjenni/reftools/cmd/fillswitch@latest" },
  { "golines", "github.com/segmentio/golines@latest" },
  { "goimports", "golang.org/x/tools/cmd/goimports@latest" },
  { "gofumpt", "mvdan.cc/gofumpt@latest" },
  { "json-to-struct", "github.com/tmc/json-to-struct@latest" },
  { "richgo", "github.com/kyoh86/richgo@latest" },
  { "ginkgo", "github.com/onsi/ginkgo/v2/ginkgo@latest" },
  { "impl", "github.com/josharian/impl@latest" },
  { "govulncheck", "golang.org/x/vuln/cmd/govulncheck@latest" },
  { "gotestsum", "gotest.tools/gotestsum@latest" },
  { "callgraph", "golang.org/x/tools/cmd/callgraph@latest" },
  { "gomvp", "golang.org/x/tools/cmd/gomvpkg@latest" },
  { "mockgen", "go.uber.org/mock/mockgen@latest" },
  { "iferr", "github.com/koron/iferr@latest" },
  { "gojsonstruct", "github.com/mholt/json-to-go/cmd/json-to-go@latest" },
  { "gotests", "github.com/cweill/gotests/gotests@latest" },
  { "gomodifytags", "github.com/fatih/gomodifytags@latest" },
}

function M.is_installed()
  return helpers.command_exists("go")
end

-- Check which Go tools are missing
function M.get_missing_tools()
  local missing = {}
  for _, tool in ipairs(M.tools) do
    local binary_name = tool[1]
    if not helpers.command_exists(binary_name) then
      table.insert(missing, tool)
    end
  end
  return missing
end

function M.install()
  if M.is_installed() then
    vim.notify("Go is already installed", vim.log.levels.INFO)
    return true
  end

  vim.notify("Installing Go...", vim.log.levels.INFO)
  local go_version = "1.22.1" -- Latest stable as of March 2024
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
    "export PATH=$PATH:$GOROOT/bin:$GOPATH/bin",
  }

  for _, var in ipairs(env_vars) do
    os.execute("echo '" .. var .. "' >> " .. shell_rc)
  end

  vim.notify(
    "Go installation complete! Please run 'source " .. shell_rc .. "' to update your environment",
    vim.log.levels.SUCCESS
  )
end

-- Install a single Go tool
function M.install_tool(tool)
  local binary_name = tool[1]
  local install_path = tool[2]
  vim.notify("Installing " .. binary_name .. "...", vim.log.levels.INFO)
  local result = os.execute("go install -v " .. install_path)
  if result == 0 then
    vim.notify("Installed " .. binary_name, vim.log.levels.INFO)
  else
    vim.notify("Failed to install " .. binary_name, vim.log.levels.ERROR)
  end
  return result == 0
end

-- Install all missing Go tools
function M.install_tools()
  if not M.is_installed() then
    vim.notify("Go is not installed. Please install it first.", vim.log.levels.WARN)
    return
  end

  local missing = M.get_missing_tools()
  if #missing == 0 then
    vim.notify("All Go tools are already installed!", vim.log.levels.INFO)
    return
  end

  vim.notify("Installing " .. #missing .. " missing Go tools...", vim.log.levels.INFO)
  local installed = 0
  local failed = 0

  for _, tool in ipairs(missing) do
    if M.install_tool(tool) then
      installed = installed + 1
    else
      failed = failed + 1
    end
  end

  vim.notify(
    string.format("Go tools installation complete! Installed: %d, Failed: %d", installed, failed),
    vim.log.levels.SUCCESS
  )
end

function M.update()
  if not M.is_installed() then
    vim.notify("Go is not installed. Please install it first.", vim.log.levels.WARN)
    return
  end

  vim.notify("Updating Go tools...", vim.log.levels.INFO)

  local updated = 0
  local failed = 0

  for _, tool in ipairs(M.tools) do
    local binary_name = tool[1]
    local install_path = tool[2]
    vim.notify("Updating " .. binary_name .. "...", vim.log.levels.INFO)
    local result = os.execute("go install -v " .. install_path)
    if result == 0 then
      updated = updated + 1
    else
      failed = failed + 1
      vim.notify("Failed to update " .. binary_name, vim.log.levels.WARN)
    end
  end

  vim.notify(
    string.format("Go tools update complete! Updated: %d, Failed: %d", updated, failed),
    vim.log.levels.SUCCESS
  )
end

return M
