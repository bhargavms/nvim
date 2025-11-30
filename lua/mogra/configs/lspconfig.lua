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

  vim.lsp.config("kotlin_language_server", {
    cmd = { "kotlin-ls", "--stdio" },
    root_markers = { "build.gradle", "build.gradle.kts", "pom.xml" },
  })

  vim.lsp.config("graphql", {
    filetypes = {
      "graphql",
      "gql",
      "graphqls",
    },
  })

  vim.lsp.config("yamlls", {})

  -- Enable all configured servers
  vim.lsp.enable({
    "lua_ls",
    "terraformls",
    "sqlls",
    "jdtls",
    "kotlin_language_server",
    "graphql",
    "yamlls",
  })
end

return M.defaults
