local M = {}

-- Helper function to register a tool module
-- Tools can use either the old API (install/update functions) or
-- the new API (install_cmd/update_cmd strings or get_install_cmd/get_update_cmd functions)
local function register_tool(tools, module_path)
  local ok, tool = pcall(require, module_path)
  if ok and tool then
    table.insert(tools, tool)
  else
    vim.notify("Failed to load tool: " .. module_path .. " - " .. tostring(tool), vim.log.levels.WARN)
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

  -- Register Java tool
  register_tool(tools, "mogra.toolchain.java")

  -- Register Android SDK tool
  register_tool(tools, "mogra.toolchain.android_sdk")

  -- Register Kotlin LSP tool
  register_tool(tools, "mogra.toolchain.kotlin-lsp")

  -- Test tools
  register_tool(tools, "mogra.toolchain.tools.dummy-fail")

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

  -- Homebrew-based tools (defined inline to avoid load-order issues with the plugin)
  local function brew_tool(name, cmd, description, package_name)
    package_name = package_name or name
    return {
      name = name,
      description = description,
      is_installed = function()
        return vim.fn.executable(cmd) == 1
      end,
      get_install_cmd = function()
        if vim.fn.executable("brew") ~= 1 then
          return nil, "Homebrew is not installed"
        end
        return "brew install " .. package_name
      end,
      get_update_cmd = function()
        if vim.fn.executable("brew") ~= 1 then
          return nil, "Homebrew is not installed"
        end
        return "brew upgrade " .. package_name
      end,
    }
  end

  table.insert(tools, brew_tool("cmake", "cmake", "cmake tool for building c++ code"))
  table.insert(tools, brew_tool("clang-format", "clang-format", "C/C++/Objective-C code formatter"))
  table.insert(tools, brew_tool("ripgrep", "rg", "Ripgrep (rg) - fast line-oriented search tool"))
  -- Terraform: prefer HashiCorp tap to get the official formula/cask.
  table.insert(tools, {
    name = "terraform",
    description = "Terraform CLI (provides terraform fmt)",
    is_installed = function()
      return vim.fn.executable("terraform") == 1
    end,
    get_install_cmd = function()
      if vim.fn.executable("brew") ~= 1 then
        return nil, "Homebrew is not installed"
      end
      return "brew tap hashicorp/tap && brew install hashicorp/tap/terraform"
    end,
    get_update_cmd = function()
      if vim.fn.executable("brew") ~= 1 then
        return nil, "Homebrew is not installed"
      end
      return "brew tap hashicorp/tap && brew upgrade hashicorp/tap/terraform"
    end,
  })
  table.insert(tools, brew_tool("tree-sitter-cli", "tree-sitter", "Tree-sitter CLI for building parsers from grammars"))
  table.insert(tools, brew_tool("luacheck", "luacheck", "Lua linter (used for checking Neovim config and Lua projects)"))
  table.insert(tools, brew_tool("xcbeautify", "xcbeautify", "Xcode build log formatter for readable output"))
  table.insert(tools, brew_tool("fzf", "fzf", "Fuzzy finder (required for fzf-lua)"))
  table.insert(tools, brew_tool("fd", "fd", "Fast file finder (improves fzf-lua/telescope performance)"))

  return tools
end

return M
