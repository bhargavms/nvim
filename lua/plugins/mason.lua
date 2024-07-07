return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "mogra.configs.mason"
    end,
    config = function(_, opts)
      require("mason").setup(opts)
    vim.api.nvim_create_user_command("MasonInstallAll", function()
        require("ui.mason").install_all(opts.ensure_installed)
    end, {})
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim"
  },
}
