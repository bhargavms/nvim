-- Matches WezTerm: rose-pine-moon (dark) / GruvboxLight (light)
local theme_watcher = require "mogra.os.theme_watcher"

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local function apply_theme(theme)
        if theme == "light" then
          vim.o.background = "light"
          vim.cmd.colorscheme "gruvbox"
        else
          vim.o.background = "dark"
          vim.cmd.colorscheme "rose-pine-moon"
        end
      end

      theme_watcher.setup(apply_theme)
    end,
  },
}
