local M = {}

function M.register_default_tools(plugin)
  -- Register Go tool
  local go = require("mogra.toolchain.go")
  plugin.register({
    name = go.name,
    description = go.description,
    install = go.install,
    update = go.update,
    is_installed = go.is_installed
  })

  -- Register NPM tool
  local npm = require("mogra.toolchain.npm")
  plugin.register({
    name = npm.name,
    description = npm.description,
    install = npm.install,
    update = npm.update,
    is_installed = npm.is_installed
  })

  -- Register LuaRocks tool
  local luarocks = require("mogra.toolchain.luarocks")
  plugin.register({
    name = luarocks.name,
    description = luarocks.description,
    install = luarocks.install,
    update = luarocks.update,
    is_installed = luarocks.is_installed
  })

  -- Register Ripgrep tool
  local ripgrep = require("mogra.toolchain.ripgrep")
  plugin.register({
    name = ripgrep.name,
    description = ripgrep.description,
    install = ripgrep.install,
    update = ripgrep.update,
    is_installed = ripgrep.is_installed
  })
end

return M
