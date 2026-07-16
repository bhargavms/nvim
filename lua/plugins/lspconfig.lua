return {
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    dependencies = { "b0o/schemastore.nvim" },
    config = require "mogra.configs.lspconfig",
  },
}
