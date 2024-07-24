return {
  'Wansmer/treesj',
  keys = {
    { '<leader>m', desc = '[T]oggle [M]ultiline' },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    -- local lang_utils = require 'treesj.langs.utils'

    require('treesj').setup {
      use_default_keymaps = false,
      max_join_length = 256,
      langs = {
        terraform = {
          tuple = {
            both = {
              separator = ',',
            },
            split = {
              last_separator = true,
            },
          },
          -- Not working
          -- function_arguments = lang_utils.set_preset_for_args(),
        },
      },
    }

    vim.keymap.set('n', '<leader>m', function()
      require('treesj').toggle()
    end, { silent = true, desc = '[T]oggle [M]ultiline' })
  end,
}
