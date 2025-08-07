local M = {}

function M.get()
  local tools = {}

  -- Register Go tool
  local go = require "mogra.toolchain.go"
  table.insert(tools, {
    name = go.name,
    description = go.description,
    install = go.install,
    update = go.update,
    is_installed = go.is_installed,
  })

  -- Register NPM tool
  local npm = require "mogra.toolchain.npm"
  table.insert(tools, {
    name = npm.name,
    description = npm.description,
    install = npm.install,
    update = npm.update,
    is_installed = npm.is_installed,
  })

  -- Register LuaRocks tool
  local luarocks = require "mogra.toolchain.luarocks"
  table.insert(tools, {
    name = luarocks.name,
    description = luarocks.description,
    install = luarocks.install,
    update = luarocks.update,
    is_installed = luarocks.is_installed,
  })

  -- Register Ripgrep tool
  local ripgrep = require "mogra.toolchain.ripgrep"
  table.insert(tools, {
    name = ripgrep.name,
    description = ripgrep.description,
    install = ripgrep.install,
    update = ripgrep.update,
    is_installed = ripgrep.is_installed,
  })

  -- Register Java tool
  local java = require "mogra.toolchain.java"
  table.insert(tools, {
    name = java.name,
    description = java.description,
    install = java.install,
    update = java.update,
    is_installed = java.is_installed,
  })

  -- Register Android SDK tool
  local android_sdk = require "mogra.toolchain.android_sdk"
  table.insert(tools, {
    name = android_sdk.name,
    description = android_sdk.description,
    install = android_sdk.install,
    update = android_sdk.update,
    is_installed = android_sdk.is_installed,
  })

  -- Register Kotlin LSP tool
  local kotlin_lsp = require "mogra.toolchain.kotlin-lsp"
  table.insert(tools, {
    name = kotlin_lsp.name,
    description = kotlin_lsp.description,
    install = kotlin_lsp.install,
    update = kotlin_lsp.update,
    is_installed = kotlin_lsp.is_installed,
  })

  local brew_tool = require "mogra_toolchain.plugins.homebrew"
  table.insert(tools, brew_tool.tool("cmake"):description("cmake tool for building c++ code"):build())

  return tools
end

return M
