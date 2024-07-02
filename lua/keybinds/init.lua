local custom_binds = {}

local function set_keybind(mode, lhs, rhs, opts)
    local desc = opts.desc
    table.insert(custom_binds, {
		mode = mode,
		lhs = lhs,
		rhs = rhs,
		desc = desc or ""
    })
    if not desc then
	error("Description (desc) is required")
    end
    vim.keymap.set(mode, lhs, rhs, opts)  
end

vim.g.set_custom_binds = set_keybind

local function load_keybinds()
  local keybinds_path = vim.fn.stdpath('config') .. '/lua/keybinds/'
  local keybind_files = vim.fn.readdir(keybinds_path, [[v:val =~ '\.lua$']])

  for _, file in ipairs(keybind_files) do
    if file ~= 'init.lua' then
      local keybind_module = 'keybinds.' .. file:gsub('%.lua$', '')
      require(keybind_module)
    end
  end
end

load_keybinds()

local M = {}

function M.generate_help()
    local keybinds_path = vim.fn.stdpath('config') .. '/lua/keybinds/'
    local help_file_path = vim.fn.stdpath('config') .. '/doc/keybinds.txt'
    
    local help_lines = {
        '*keybinds.txt*    Displays all of my custom keybinds',
        '==============================================================================',
        'Keybinds Help                          *My Custom Keybinds*',
        '',
        'Introduction',
        '==============================================================================',
        'This help file contains all the custom keybindings defined in this Neovim',
        'configuration.',
        '',
        'Keybindings',
        '==============================================================================',
        '',
    }
	for _, keybind in ipairs(custom_binds) do
		table.insert(help_lines, string.format('%-20s %s', keybind.lhs, keybind.desc))
	end

    table.insert(help_lines, '')
    table.insert(help_lines, 'vim:tw=78:ts=8:ft=help:norl:')

    local file = io.open(help_file_path, "w")
    for _, line in ipairs(help_lines) do
        file:write(line .. "\n")
    end
    file:close()

	vim.cmd('helptags ' .. vim.fn.stdpath('config') .. '/doc')
end

local function load_autocommands()
    local augroup = vim.api.nvim_create_augroup
    local autocmd = vim.api.nvim_create_autocmd

    local group = augroup('GenerateKeybindsHelp', { clear = true })

    autocmd('BufWritePost', {
        group = group,
        pattern = vim.fn.stdpath('config') .. '/lua/keybinds/*.lua',
        callback = function()
	    M.generate_help()	    
        end,
    })
end

load_autocommands()

