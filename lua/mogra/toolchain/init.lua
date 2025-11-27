local M = {}

-- Helper function to register a tool module
local function register_tool(tools, module_path)
  local ok, tool = pcall(require, module_path)
  if ok and tool then
    table.insert(tools, {
      name = tool.name,
      description = tool.description,
      install = tool.install,
      update = tool.update,
      is_installed = tool.is_installed,
    })
  end
end

function M.get()
  local tools = {}

  -- Register Go tool (the language itself)
  register_tool(tools, "mogra.toolchain.go")

  -- Register NPM tool
  register_tool(tools, "mogra.toolchain.npm")

  -- Register LuaRocks tool
  register_tool(tools, "mogra.toolchain.luarocks")

  -- Register Ripgrep tool
  register_tool(tools, "mogra.toolchain.ripgrep")

  -- Register Java tool
  register_tool(tools, "mogra.toolchain.java")

  -- Register Android SDK tool
  register_tool(tools, "mogra.toolchain.android_sdk")

  -- Register Kotlin LSP tool
  register_tool(tools, "mogra.toolchain.kotlin-lsp")

  -- pip-based tools
  register_tool(tools, "mogra.toolchain.tools.beautysh")
  register_tool(tools, "mogra.toolchain.tools.yamlfix")

  -- npm-based tools
  register_tool(tools, "mogra.toolchain.tools.prettier")
  register_tool(tools, "mogra.toolchain.tools.prettierd")

  -- Go tools (individual)
  register_tool(tools, "mogra.toolchain.tools.go.gopls")
  register_tool(tools, "mogra.toolchain.tools.go.dlv")
  register_tool(tools, "mogra.toolchain.tools.go.golangci-lint")
  register_tool(tools, "mogra.toolchain.tools.go.gonew")
  register_tool(tools, "mogra.toolchain.tools.go.go-enum")
  register_tool(tools, "mogra.toolchain.tools.go.fillswitch")
  register_tool(tools, "mogra.toolchain.tools.go.golines")
  register_tool(tools, "mogra.toolchain.tools.go.goimports")
  register_tool(tools, "mogra.toolchain.tools.go.gofumpt")
  register_tool(tools, "mogra.toolchain.tools.go.json-to-struct")
  register_tool(tools, "mogra.toolchain.tools.go.richgo")
  register_tool(tools, "mogra.toolchain.tools.go.ginkgo")
  register_tool(tools, "mogra.toolchain.tools.go.impl")
  register_tool(tools, "mogra.toolchain.tools.go.govulncheck")
  register_tool(tools, "mogra.toolchain.tools.go.gotestsum")
  register_tool(tools, "mogra.toolchain.tools.go.callgraph")
  register_tool(tools, "mogra.toolchain.tools.go.gomvp")
  register_tool(tools, "mogra.toolchain.tools.go.mockgen")
  register_tool(tools, "mogra.toolchain.tools.go.iferr")
  register_tool(tools, "mogra.toolchain.tools.go.gojsonstruct")
  register_tool(tools, "mogra.toolchain.tools.go.gotests")
  register_tool(tools, "mogra.toolchain.tools.go.gomodifytags")

  -- Homebrew-based tools (using plugin's builder)
  local ok, brew_tool = pcall(require, "mogra_toolchain.plugins.homebrew")
  if ok then
    table.insert(tools, brew_tool.tool("cmake"):description("cmake tool for building c++ code"):build())
    table.insert(tools, brew_tool.tool("clang-format"):description("C/C++/Objective-C code formatter"):build())
    table.insert(tools, brew_tool.tool("terraform"):description("Terraform CLI (provides terraform_fmt)"):build())
  end

  return tools
end

return M
