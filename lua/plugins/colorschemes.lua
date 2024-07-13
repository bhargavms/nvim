return {
  -- {
  --   "ntk148v/habamax.nvim",
  --   dependencies = { "rktjmp/lush.nvim" },
  --   config = function()
  --     vim.cmd.colorscheme "habamax.nvim"
  --   end,
  -- },
  {
    "luisiacc/gruvbox-baby",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "gruvbox-baby"
    end,
  },
}
