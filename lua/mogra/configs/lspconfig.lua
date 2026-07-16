local M = {}
local map = vim.keymap.set

-- Set up LspAttach autocmd for keybindings (replaces on_attach)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local function opts(desc)
      return { buffer = bufnr, desc = "LSP " .. desc }
    end

    map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
    map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
    map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
    map("n", "K", vim.lsp.buf.hover, opts "Lsp Hover")
    map("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts "List workspace folders")

    map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
    map("n", "gr", vim.lsp.buf.references, opts "Show references")
    map("n", "<leader>er", vim.diagnostic.open_float, opts "Show diagnostic hover window")
    map("n", "<leader>jd", "<cmd>belowright split | lua vim.lsp.buf.definition()<CR>", opts "Open definition in split window")

    -- disable semanticTokens (replaces on_init)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.supports_method "textDocument/semanticTokens" then
      client.server_capabilities.semanticTokensProvider = nil
    end

    -- Xcodebuild keybinds (only for sourcekit / Xcode projects)
    if client and client.name == "sourcekit" then
      local function xopts(desc)
        return { buffer = bufnr, desc = "Xcode " .. desc }
      end

      map("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", xopts "Show Xcodebuild Actions")
      map("n", "<leader>xf", "<cmd>XcodebuildProjectManager<cr>", xopts "Show Project Manager Actions")

      map("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", xopts "Build Project")
      map("n", "<leader>xB", "<cmd>XcodebuildBuildForTesting<cr>", xopts "Build For Testing")
      map("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", xopts "Build & Run Project")

      map("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", xopts "Run Tests")
      map("v", "<leader>xt", "<cmd>XcodebuildTestSelected<cr>", xopts "Run Selected Tests")
      map("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", xopts "Run Current Test Class")
      map("n", "<leader>x.", "<cmd>XcodebuildTestRepeat<cr>", xopts "Repeat Last Test Run")

      map("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", xopts "Toggle Xcodebuild Logs")
      map("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", xopts "Toggle Code Coverage")
      map("n", "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", xopts "Show Code Coverage Report")
      map("n", "<leader>xe", "<cmd>XcodebuildTestExplorerToggle<cr>", xopts "Toggle Test Explorer")
      map("n", "<leader>xs", "<cmd>XcodebuildFailingSnapshots<cr>", xopts "Show Failing Snapshots")

      map("n", "<leader>xp", "<cmd>XcodebuildPreviewGenerateAndShow<cr>", xopts "Generate Preview")
      map("n", "<leader>x<cr>", "<cmd>XcodebuildPreviewToggle<cr>", xopts "Toggle Preview")

      map("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", xopts "Select Device")
      map("n", "<leader>xq", "<cmd>Telescope quickfix<cr>", xopts "Show QuickFix List")

      map("n", "<leader>xx", "<cmd>XcodebuildQuickfixLine<cr>", xopts "Quickfix Line")
      map("n", "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", xopts "Show Code Actions")
      map("n", "<leader>xA", "<cmd>XcodebuildAssetsManager<cr>", xopts "Show Assets Manager")
      map("n", "<leader>XX", "<cmd>XcodebuildSetup<cr>", xopts "Run Setup Wizard")
    end
  end,
})

-- Set up capabilities
M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

-- Folding capabilities
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

M.defaults = function(_, _)
  require "mogra.ui.lsp"
  local web = require "mogra.tooling.web"

  -- Configure default settings for all LSP servers
  vim.lsp.config("*", {
    capabilities = M.capabilities,
  })

  -- Configure individual servers
  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
            vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  })

  vim.lsp.config("terraformls", {})

  vim.lsp.config("sqlls", {})

  vim.lsp.config("jdtls", {})

  vim.lsp.config("graphql", {
    filetypes = {
      "graphql",
      "gql",
      "graphqls",
    },
  })

  local has_schemastore, schemastore = pcall(require, "schemastore")

  local function node_lsp(executable, args)
    return function(dispatchers, config)
      local path = config.root_dir or vim.fn.getcwd()
      local resolved = vim.fn.exepath(executable)
      local command = web.node_command(path, resolved ~= "" and resolved or executable, args)
      return vim.lsp.rpc.start(command, dispatchers)
    end
  end

  vim.lsp.config("yamlls", {
    settings = {
      yaml = {
        schemas = has_schemastore and schemastore.yaml.schemas() or {},
      },
    },
  })

  vim.lsp.config("ts_ls", {
    cmd = node_lsp("typescript-language-server", { "--stdio" }),
  })
  vim.lsp.config("angularls", {
    root_dir = function(bufnr, on_dir)
      local root = web.angular_root(vim.api.nvim_buf_get_name(bufnr))
      if root then
        on_dir(root)
      end
    end,
    cmd = function(dispatchers, config)
      local root = config.root_dir or vim.fn.getcwd()
      local node_modules = vim.fs.joinpath(root, "node_modules")
      local package = web.workspace(vim.fs.joinpath(root, "package.json")).package
      local dependencies = vim.tbl_extend("force", package.dependencies or {}, package.devDependencies or {})
      local angular_version = (dependencies["@angular/core"] or ""):match "%d+%.%d+%.%d+" or ""

      local ngserver = vim.fs.joinpath(vim.fn.stdpath "data", "mason", "bin", "ngserver")
      -- Angular Language Server 19 supports Node 18/20, so it intentionally
      -- runs on Node 20 while the application and its other tools use Node 22.
      local cmd = {
        vim.fn.exepath "mise",
        "exec",
        "node@20",
        "--",
        ngserver,
        "--stdio",
        "--tsProbeLocations",
        node_modules,
        "--ngProbeLocations",
        node_modules,
        "--angularCoreVersion",
        angular_version,
      }
      return vim.lsp.rpc.start(cmd, dispatchers)
    end,
  })
  vim.lsp.config("html", {
    cmd = node_lsp("vscode-html-language-server", { "--stdio" }),
  })
  vim.lsp.config("cssls", {
    cmd = node_lsp("vscode-css-language-server", { "--stdio" }),
  })
  vim.lsp.config("jsonls", {
    cmd = node_lsp("vscode-json-language-server", { "--stdio" }),
    settings = {
      json = {
        schemas = has_schemastore and schemastore.json.schemas() or {},
        validate = { enable = true },
      },
    },
  })

  local function linter_root(linter)
    return function(bufnr, on_dir)
      local path = vim.api.nvim_buf_get_name(bufnr)
      local workspace = web.workspace(path)
      if workspace.linter == linter then
        on_dir(workspace.root)
      end
    end
  end

  vim.lsp.config("oxlint", {
    cmd = function(dispatchers, config)
      local root = config.root_dir or vim.fn.getcwd()
      local executable = vim.fs.joinpath(root, "node_modules", ".bin", "oxlint")
      if vim.fn.executable(executable) ~= 1 then
        executable = "oxlint"
      end
      return vim.lsp.rpc.start(web.node_command(root, executable, { "--lsp" }), dispatchers)
    end,
    root_dir = linter_root "oxlint",
  })

  local eslint_before_init = vim.lsp.config.eslint.before_init
  vim.lsp.config("eslint", {
    cmd = node_lsp("vscode-eslint-language-server", { "--stdio" }),
    root_dir = linter_root "eslint",
    before_init = function(params, config)
      if eslint_before_init then
        eslint_before_init(params, config)
      end

      local rule_path = config.root_dir and vim.fs.joinpath(config.root_dir, "lint-rules") or nil
      if rule_path and vim.fn.isdirectory(rule_path) == 1 then
        config.settings = config.settings or {}
        config.settings.options = vim.tbl_deep_extend("force", config.settings.options or {}, {
          rulePaths = { rule_path },
        })
      end
    end,
    settings = {
      format = false,
      workingDirectory = { mode = "auto" },
    },
  })

  -- Swift / sourcekit-lsp
  vim.lsp.config("sourcekit", {
    cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
    filetypes = { "swift", "objc", "objcpp", "c", "cpp" },
    root_markers = { "Package.swift", "*.xcworkspace", ".git" },
  })

  -- Enable all configured servers
  vim.lsp.enable({
    "lua_ls",
    "terraformls",
    "sqlls",
    "jdtls",
    "kotlin_language_server",
    "graphql",
    "yamlls",
    "ts_ls",
    "angularls",
    "html",
    "cssls",
    "jsonls",
    "oxlint",
    "eslint",
    "sourcekit",
  })
end

return M.defaults
