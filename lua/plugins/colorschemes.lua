-- return {
--   -- {
--   --   "ntk148v/habamax.nvim",
--   --   dependencies = { "rktjmp/lush.nvim" },
--   --   config = function()
--   --     vim.cmd.colorscheme "habamax.nvim"
--   --   end,
--   -- },
--   {
--     "luisiacc/gruvbox-baby",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme "gruvbox-baby"
--     end,
--   },
-- }
--
-- ~/.config/nvim/lua/plugins/colorschemes.lua
local theme_watcher = require('mogra.os.theme_watcher')

return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- Theme callback function
      local function apply_theme(theme)
        if theme == "light" then
          vim.g.gruvbox_material_background = 'light'
        else
          vim.g.gruvbox_material_background = 'dark'
        end
        vim.cmd.colorscheme "gruvbox-material"
	vim.g.gruvbox_material_enable_italic = 1
	vim.g.gruvbox_material_disable_italic_comment = 0
      end

      -- Setup theme watcher with our callback
      theme_watcher.setup(apply_theme)
    end,
  },
}
