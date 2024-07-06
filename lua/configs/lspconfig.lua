local M = {}
local map = vim.g.set_custom_binds

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
	require("keybinds.lspclient_bindings").load_lsp_client_bindings(map, bufnr)
end

-- disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

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

M.defaults = function()

  require("lspconfig").lua_ls.setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    on_init = M.on_init,

    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
            vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
            vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  }
end

return M

