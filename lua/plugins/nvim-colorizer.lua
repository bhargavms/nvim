return {
  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    opts = { user_default_options = { names = false } },
    config = require "mogra.configs.nvim-colorizer",
  },
}
