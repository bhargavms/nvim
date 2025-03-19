return {
  {
    "kevinhwang91/nvim-bqf",
    opts = function()
      return require "mogra.options.better-quick-fix"
    end,
    config = require "mogra.configs.better-quick-fix",
  },
}
