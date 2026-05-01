local function init(_, opts)
  require("snacks").setup(opts)

  -- Keymaps for snacks features
  local Snacks = require("snacks")

  -- Notifier
  vim.keymap.set("n", "<leader>un", function()
    Snacks.notifier.hide()
  end, { desc = "Dismiss all notifications" })

  -- Buffer delete
  vim.keymap.set("n", "<leader>bd", function()
    Snacks.bufdelete()
  end, { desc = "Delete buffer" })

  -- Git
  vim.keymap.set("n", "<leader>gb", function()
    Snacks.git.blame_line()
  end, { desc = "Git blame line" })
  vim.keymap.set("n", "<leader>gB", function()
    Snacks.gitbrowse()
  end, { desc = "Git browse" })

  -- Terminal
  vim.keymap.set("n", "<leader>gg", function()
    Snacks.lazygit()
  end, { desc = "Lazygit" })
  vim.keymap.set("n", "<c-/>", function()
    Snacks.terminal()
  end, { desc = "Toggle terminal" })

  -- Claude Code
  vim.keymap.set("n", "<leader>ac", function()
    Snacks.terminal("claude", {
      cwd = vim.fn.getcwd(),
      win = {
        position = "float",
        border = "rounded",
        width = 0.8,
        height = 0.8,
        title = " Claude Code ",
        title_pos = "center",
      },
    })
  end, { desc = "Claude Code" })

  -- Words (reference jumping)
  vim.keymap.set("n", "]]", function()
    Snacks.words.jump(vim.v.count1)
  end, { desc = "Next reference" })
  vim.keymap.set("n", "[[", function()
    Snacks.words.jump(-vim.v.count1)
  end, { desc = "Prev reference" })
end

return init
