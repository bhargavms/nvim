local function init(_, opts)
  require("fzf-lua").setup(opts)

  local fzf = require("fzf-lua")
  local map = vim.keymap.set

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ fzf-lua: File/Grep operations (faster than Telescope)   │
  -- ╰──────────────────────────────────────────────────────────╯

  -- Files
  map("n", "<leader>ff", fzf.files, { desc = "Find files (fzf)" })
  map("n", "<leader>fo", fzf.oldfiles, { desc = "Recent files (fzf)" })
  map("n", "<leader>fb", fzf.buffers, { desc = "Find buffers (fzf)" })
  map("n", "<leader>fa", function()
    fzf.files({ cmd = "fd --type f --hidden --follow --no-ignore" })
  end, { desc = "Find all files (fzf)" })

  -- Grep
  map("n", "<leader>fw", fzf.live_grep, { desc = "Live grep (fzf)" })
  map("n", "<leader>fW", fzf.grep_cword, { desc = "Grep word under cursor (fzf)" })
  map("v", "<leader>fw", fzf.grep_visual, { desc = "Grep selection (fzf)" })
  map("n", "<leader>fz", fzf.grep_curbuf, { desc = "Grep current buffer (fzf)" })

  -- Git
  map("n", "<leader>cm", fzf.git_commits, { desc = "Git commits (fzf)" })
  map("n", "<leader>gt", fzf.git_status, { desc = "Git status (fzf)" })
  map("n", "<leader>gf", fzf.git_files, { desc = "Git files (fzf)" })

  -- Misc (non-LSP)
  map("n", "<leader>fh", fzf.help_tags, { desc = "Help tags (fzf)" })
  map("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps (fzf)" })
  map("n", "<leader>ma", fzf.marks, { desc = "Marks (fzf)" })
  map("n", "<leader>f:", fzf.command_history, { desc = "Command history (fzf)" })

  -- Resume & Quickfix
  map("n", "<leader>f.", fzf.resume, { desc = "Resume last picker (fzf)" })
  map("n", "<leader>fq", fzf.quickfix, { desc = "Quickfix list (fzf)" })
end

return init
