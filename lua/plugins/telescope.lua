return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "mogra.options.telescope"
    end,
    config = require "mogra.configs.telescope",
  },
}
