local M = {}

local function start_dir(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == "directory" and path or vim.fs.dirname(path)
end

local function find_up(path, names)
  local match = vim.fs.find(names, {
    path = start_dir(path),
    upward = true,
    type = "file",
    limit = 1,
  })[1]
  return match and vim.fs.dirname(match) or nil
end

local function read_package(root)
  if not root then
    return {}
  end

  local package_path = vim.fs.joinpath(root, "package.json")
  local ok, lines = pcall(vim.fn.readfile, package_path)
  if not ok then
    return {}
  end

  local decoded_ok, package = pcall(vim.json.decode, table.concat(lines, "\n"))
  return decoded_ok and package or {}
end

local function has_dependency(package, name)
  return (package.dependencies and package.dependencies[name] ~= nil)
    or (package.devDependencies and package.devDependencies[name] ~= nil)
end

---@param path string
---@return table
function M.workspace(path)
  local root = find_up(path, { "package.json" })
  local package = read_package(root)
  local engines = package.engines or {}
  local node_major = type(engines.node) == "string" and engines.node:match "%d+" or nil

  local formatter
  if has_dependency(package, "oxfmt") then
    formatter = "oxfmt"
  elseif has_dependency(package, "prettier") then
    formatter = "prettier"
  end

  local linter
  if has_dependency(package, "oxlint") then
    linter = "oxlint"
  elseif has_dependency(package, "eslint") then
    linter = "eslint"
  end

  local jest_config = root and vim.fs.joinpath(root, "jest.config.js") or nil
  if jest_config and vim.uv.fs_stat(jest_config) == nil then
    jest_config = nil
  end

  return {
    root = root,
    package = package,
    formatter = formatter,
    linter = linter,
    node_major = node_major,
    jest_config = jest_config,
  }
end

local function node_command(workspace, executable, args)
  local command = { executable }
  if workspace.node_major and vim.fn.executable "mise" == 1 then
    command = { "mise", "exec", "node@" .. workspace.node_major, "--", executable }
  end
  return vim.list_extend(command, args or {})
end

---@param path string
---@param executable string
---@param args? string[]
---@return string[]
function M.node_command(path, executable, args)
  return node_command(M.workspace(path), executable, args)
end

---@param path string
---@return string
function M.jest_command(path)
  local workspace = M.workspace(path)
  local command = workspace.root and "./node_modules/.bin/jest" or "jest"
  return table.concat(node_command(workspace, command), " ")
end

---@param path string
---@return boolean
function M.is_angular_template(path)
  if not path:match "%.html$" then
    return false
  end

  return M.angular_root(path) ~= nil
end

---@param path string
---@return string|nil
function M.angular_root(path)
  local angular_root = find_up(path, { "angular.json" })
  local package_root = find_up(path, { "package.json" })
  return angular_root ~= nil and angular_root == package_root and angular_root or nil
end

function M.setup_filetypes()
  vim.filetype.add({
    pattern = {
      [".*%.html"] = {
        function(path)
          if M.is_angular_template(path) then
            return "htmlangular"
          end
        end,
        { priority = 10 },
      },
    },
  })

  vim.treesitter.language.register("angular", "htmlangular")
end

return M
