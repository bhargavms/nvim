return {
  {
    "ntk148v/habamax.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      vim.cmd.colorscheme "habamax.nvim"
    end,
  },
}
