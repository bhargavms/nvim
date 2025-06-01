local M = {}

local helpers = require("mogra.toolchain.helpers")

M.name = "NPM"
M.description = "Node.js and npm via nvm"

function M.is_installed()
  return helpers.command_exists("npm") or vim.fn.filereadable(os.getenv("HOME") .. "/.nvm/nvm.sh") == 1
end

function M.install()
  if M.is_installed() then
    vim.notify("NPM is already installed", vim.log.levels.INFO)
    return
  end

  vim.notify("Installing Node.js and npm via nvm...", vim.log.levels.INFO)

  -- Check if nvm is installed
  if not helpers.command_exists("nvm") and not vim.fn.filereadable(os.getenv("HOME") .. "/.nvm/nvm.sh") then
    vim.notify("Installing nvm...", vim.log.levels.INFO)
    local nvm_version, _ = helpers.get_latest_github_release("nvm-sh/nvm")
    nvm_version = nvm_version or "v0.40.3"
    os.execute("curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/" .. nvm_version .. "/install.sh | bash")
  end

  -- Install Node.js LTS and update npm
  vim.notify("Installing latest Node.js LTS...", vim.log.levels.INFO)
  os.execute("source $HOME/.nvm/nvm.sh && nvm install --lts && nvm use --lts")
  os.execute("source $HOME/.nvm/nvm.sh && npm install -g npm@latest")

  vim.notify("Node.js and npm installation complete!", vim.log.levels.SUCCESS)
end

function M.update()
  if not M.is_installed() then
    vim.notify("NPM is not installed. Please install it first.", vim.log.levels.WARN)
    return
  end

  vim.notify("Updating NPM...", vim.log.levels.INFO)
  os.execute("npm install -g npm@latest")
  vim.notify("NPM update complete!", vim.log.levels.SUCCESS)
end

return M
