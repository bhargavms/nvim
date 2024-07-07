return {
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("mogra.configs.lspconfig").defaults()
    end,
  },
}
