local function init(_, _)
  -- Folding options
  vim.o.foldcolumn = "1" -- show fold column
  vim.o.foldlevel = 99 -- start with all folds open
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  -- Keymaps
  vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
  vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
  vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
  vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with level" })
  vim.keymap.set("n", "zK", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
      vim.lsp.buf.hover()
    end
  end, { desc = "Peek fold or hover" })

  -- Fold text customization
  local function fold_virt_text_handler(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ("  %d lines"):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0

    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end

    table.insert(newVirtText, { suffix, "Comment" })
    return newVirtText
  end

  -- Check if treesitter parser is available for a filetype
  local function has_treesitter_parser(filetype)
    local parsers = require("nvim-treesitter.parsers")
    local lang = parsers.ft_to_lang(filetype)
    return parsers.has_parser(lang)
  end

  require("ufo").setup({
    -- Provider selector: returns provider names, ufo handles fallback automatically
    provider_selector = function(_, filetype, buftype)
      -- Skip special buffers
      if buftype == "nofile" or buftype == "terminal" then
        return ""
      end

      -- Filetypes that work well with indent-based folding
      local indent_filetypes = { "python", "yaml", "markdown" }
      if vim.tbl_contains(indent_filetypes, filetype) then
        return { "indent" }
      end

      -- Build provider chain: LSP → treesitter (if parser exists) → indent
      if has_treesitter_parser(filetype) then
        return { "lsp", "treesitter" }
      end

      -- No treesitter parser, fallback to indent
      return { "lsp", "indent" }
    end,

    -- Preview window config
    preview = {
      win_config = {
        border = "rounded",
        winhighlight = "Normal:Normal",
        winblend = 0,
      },
      mappings = {
        scrollU = "<C-u>",
        scrollD = "<C-d>",
        jumpTop = "[",
        jumpBot = "]",
      },
    },

    fold_virt_text_handler = fold_virt_text_handler,
  })
end

return init
