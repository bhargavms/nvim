return {
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = require "mogra.configs.lspconfig",
  },
}
