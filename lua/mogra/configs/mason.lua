local function mason_options(opts)
  local result = vim.deepcopy(opts)
  result.lsp_servers = nil
  result.tools = nil
  return result
end

local function install_package(identifier, is_lsp)
  local Package = require "mason-core.package"
  local name, version = Package.Parse(identifier)

  if is_lsp then
    local mappings = require("mason-lspconfig").get_mappings()
    name = mappings.lspconfig_to_package[name]
  end

  if not name then
    vim.notify("No Mason package mapping for " .. identifier, vim.log.levels.WARN)
    return
  end

  local ok, package = pcall(require("mason-registry").get_package, name)
  if not ok then
    vim.notify("Mason package is unavailable: " .. name, vim.log.levels.WARN)
    return
  end

  local installed = package:is_installed()
  local version_mismatch = version ~= nil and package:get_installed_version() ~= version
  if (not installed or version_mismatch) and not package:is_installing() then
    package:install({ version = version, force = installed })
  end
end

local function install_all(opts)
  require("mason-registry").refresh(function()
    for _, server in ipairs(opts.lsp_servers or {}) do
      install_package(server, true)
    end
    for _, tool in ipairs(opts.tools or {}) do
      install_package(tool, false)
    end
  end)
end

local function init(_, opts)
  require("mason").setup(mason_options(opts))
  require("mason-lspconfig").setup({
    ensure_installed = opts.lsp_servers or {},
    automatic_enable = false,
  })

  vim.api.nvim_create_user_command("MasonInstallAll", function()
    install_all(opts)
  end, {})
end

return init
