local masonames = require "mogra.ui.mason.names"

-- LSP servers that should be installed via Mason
-- This list should match the servers enabled in mogra.configs.lspconfig
local lsp_servers = {
  "lua_ls",
  "terraformls",
  "sqlls",
  "jdtls",
  "kotlin_language_server",
  "graphql",
  "yamlls",
}

local get_pkgs = function(data)
  local tools = data or {}

  -- Add LSP servers
  tools = vim.list_extend(tools, lsp_servers)

  local conform_exists, conform = pcall(require, "conform")

  if conform_exists then
    local formatters = conform.list_all_formatters()

    local formatters_names = vim.tbl_map(function(formatter)
      return formatter.name
    end, formatters)

    tools = vim.list_extend(tools, formatters_names)
  end

  local lint_exists, lint = pcall(require, "lint")

  if lint_exists then
    local linters = lint.linters_by_ft

    for _, v in pairs(linters) do
      table.insert(tools, v[1])
    end
  end

  -- rm duplicates
  local pkgs = {}

  for _, v in pairs(tools) do
    if not (vim.tbl_contains(pkgs, masonames[v])) then
      table.insert(pkgs, masonames[v])
    end
  end

  return pkgs
end

local install_all = function(data)
  vim.cmd "Mason"

  local mr = require "mason-registry"

  mr.refresh(function()
    for _, tool in ipairs(get_pkgs(data)) do
      local p = mr.get_package(tool)

      if not p:is_installed() then
        p:install()
      end
    end
  end)
end

local function init(_, opts)
  require("mason").setup(opts)
  vim.api.nvim_create_user_command("MasonInstallAll", function()
    install_all(opts.ensure_installed)
  end, {})
end

return init
