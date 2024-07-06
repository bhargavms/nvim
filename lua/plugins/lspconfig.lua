return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall",  "MasonUpdate" },
    opts = function()
      return require "configs.mason"
    end,
    config = function(_, opts)
      require("mason").setup(opts)

    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("configs.lspconfig").defaults()
    end,
  },
}
