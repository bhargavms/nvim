return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- NOTE: nvim-treesitter (main) is a rewrite and explicitly does not support lazy-loading.
    lazy = false,
    build = ":TSUpdate",
    opts = function()
      return require "mogra.options.treesitter"
    end,
    config = function(_, opts)
      require("mogra.configs.treesitter").setup(opts)
    end,
  },
}
