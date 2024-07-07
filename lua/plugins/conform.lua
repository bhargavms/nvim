return {
  {
    "stevearc/conform.nvim",
    opts = function()
      return require "mogra.options.conform"
    end,
    config = require "mogra.configs.conform",
  },
}
