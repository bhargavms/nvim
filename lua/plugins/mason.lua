return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    opts = function()
      return require "mogra.options.mason"
    end,
    config = require "mogra.configs.mason",
  },
}
