local M = {}

local models = require "mogra.toolchain.models"

-- Read a file's contents
---@param path string
---@return string|nil
local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local content = file:read "*a"
  file:close()
  return content
end

-- Run a shell command and return its output
---@param cmd string
---@return string|nil
local function run_command(cmd)
  local handle = io.popen(cmd)
  if handle then
    local result = handle:read "*a"
    handle:close()
    return result
  end
  return nil
end

-- Parse JSON string into Lua table
---@param str string
---@return table
local function parse_json(str)
  local success, result = pcall(vim.fn.json_decode, str)
  if success then
    return result
  end
  error("Failed to parse JSON: " .. tostring(result))
end

-- Get the path to a GraphQL query file
---@param query_name string
---@return string
local function get_query_path(query_name)
  return vim.fn.stdpath "config" .. "/lua/mogra/toolchain/graphql/" .. query_name .. ".graphql"
end

-- Get GitHub token from environment
---@return string|nil
local function get_github_token()
  return os.getenv "GITHUB_TOKEN"
end

-- Execute a GraphQL query
---@param query_name string
---@param variables table
---@return table|nil
function M.execute_query(query_name, variables)
  -- Read the query file
  local query_path = get_query_path(query_name)
  local query = read_file(query_path)
  if not query then
    vim.notify("Failed to read GraphQL query: " .. query_name, vim.log.levels.ERROR)
    return nil
  end

  -- Get GitHub token
  local token = get_github_token()
  if not token then
    vim.notify("GITHUB_TOKEN environment variable not set", vim.log.levels.ERROR)
    return nil
  end

  -- Prepare the request body
  local request_body = {
    query = query,
    variables = variables,
  }
  local json_body = vim.fn.json_encode(request_body)

  -- Execute the query with authentication
  local cmd = string.format(
    'curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer %s" -d \'%s\' https://api.github.com/graphql',
    token,
    json_body
  )
  local response = run_command(cmd)
  if not response then
    vim.notify("Failed to execute GraphQL query: " .. query_name, vim.log.levels.ERROR)
    return nil
  end

  -- Parse and return the response
  local data = parse_json(response)
  if not data or not data.data then
    vim.notify("Invalid GraphQL response for query: " .. query_name, vim.log.levels.ERROR)
    return nil
  end

  return data.data
end

-- Get latest version from GitHub
---@param repo string
---@return string|nil
function M.get_latest_version(repo)
  local owner, name = repo:match "([^/]+)/([^/]+)"
  if not owner or not name then
    return nil
  end

  local cmd = string.format("curl -s https://api.github.com/repos/%s/%s/releases/latest", owner, name)
  local response = run_command(cmd)
  if not response then
    return nil
  end

  local data = parse_json(response)
  local release = models.parse_github_release(data)
  -- Validate release data
  local success, err = pcall(function()
    release:validate()
  end)
  if not success then
    vim.notify("Invalid GitHub release data: " .. err, vim.log.levels.ERROR)
    return nil
  end

  return release:get_version()
end

-- Get latest release with assets from GitHub
---@param repo string
---@return table
function M.get_latest_release(repo)
  local owner, name = repo:match "([^/]+)/([^/]+)"
  if not owner or not name then
    error "no owner"
  end

  local cmd = string.format("curl -s https://api.github.com/repos/%s/%s/releases/latest", owner, name)
  local response = run_command(cmd)
  if not response then
    error "no response from curl"
  end

  local data = parse_json(response)
  local release = models.parse_github_release(data)

  -- Validate release data
  local success, err = pcall(function()
    release:validate()
  end)
  if not success then
    error("Invalid GitHub release data: " .. err, vim.log.levels.ERROR)
  end

  -- Transform the response to match our model structure
  local release_data = {
    tag_name = release:get_version(),
    assets = {},
  }

  if release.assets then
    for _, asset in ipairs(release.assets) do
      table.insert(release_data.assets, {
        name = asset.name,
        url = asset.url,
        browser_download_url = asset.browser_download_url,
      })
    end
  end

  return release_data
end

return M
