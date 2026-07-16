local options = {
  PATH = "skip",

  lsp_servers = {
    "lua_ls",
    "terraformls",
    "sqlls",
    "jdtls",
    "kotlin_language_server",
    "graphql",
    "yamlls",
    "ts_ls",
    "angularls@19.2.4",
    "html",
    "cssls",
    "jsonls",
    "eslint",
  },

  tools = {
    "js-debug-adapter",
  },

  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = " 󰚌",
    },

    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },

  max_concurrent_installers = 10,
}

return options
