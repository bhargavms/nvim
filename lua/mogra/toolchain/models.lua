local M = {}

-- GitHub Release model
---@class GitHubRelease
---@field url string
---@field assets_url string
---@field upload_url string
---@field html_url string
---@field id number
---@field node_id string
---@field tag_name string
---@field target_commitish string
---@field name string
---@field draft boolean
---@field prerelease boolean
---@field created_at string
---@field published_at string
---@field tarball_url string
---@field zipball_url string
---@field body string
---@field get_version fun(self: GitHubRelease): string
---@field validate fun(self: GitHubRelease): boolean
local GitHubRelease = {}

-- Get version string from tag_name
---@return string
function GitHubRelease:get_version()
  return self.tag_name:gsub("^v", "")
end

-- Validate required fields
---@return boolean
---@throws string Error message if validation fails
function GitHubRelease:validate()
  if not self.tag_name then
    error("GitHub release is missing required field: tag_name")
  end
  if not self.assets then
    error("GitHub release is missing required field: assets")
  end
  if #self.assets == 0 then
    error("GitHub release has no assets")
  end
  for _, asset in ipairs(self.assets) do
    if not asset.browser_download_url then
      error("GitHub asset is missing required field: browser_download_url")
    end
    if not asset.name then
      error("GitHub asset is missing required field: name")
    end
    if not asset.content_type then
      error("GitHub asset is missing required field: content_type")
    end
    if not asset.state then
      error("GitHub asset is missing required field: state")
    end
    if asset.state ~= "uploaded" then
      error("GitHub asset is not in uploaded state: " .. asset.state)
    end
  end
  return true
end

-- Create a new SystemArchitecture instance
---@param arch string
---@param os_name string
---@return table
function M.new_system_architecture(arch, os_name)
  return {
    arch = arch,
    os_name = os_name,
    combination = arch .. "-" .. os_name
  }
end

-- Parse GitHub release from JSON data
---@param data table
---@return GitHubRelease
function M.parse_github_release(data)
  if not data then
    error "response data was nil"
  end

  -- Create a new release object
  local release = {
    url = data.url,
    assets_url = data.assets_url,
    upload_url = data.upload_url,
    html_url = data.html_url,
    id = data.id,
    author = data.author,
    node_id = data.node_id,
    tag_name = data.tag_name,
    target_commitish = data.target_commitish,
    name = data.name,
    draft = data.draft,
    prerelease = data.prerelease,
    created_at = data.created_at,
    published_at = data.published_at,
    assets = {},
    tarball_url = data.tarball_url,
    zipball_url = data.zipball_url,
    body = data.body,
    get_version = GitHubRelease.get_version,
    validate = GitHubRelease.validate,
  }

  -- Parse assets
  if data.assets then
    for _, asset_data in ipairs(data.assets) do
      table.insert(release.assets, {
        url = asset_data.url,
        id = asset_data.id,
        node_id = asset_data.node_id,
        name = asset_data.name,
        label = asset_data.label,
        uploader = asset_data.uploader,
        content_type = asset_data.content_type,
        state = asset_data.state,
        size = asset_data.size,
        download_count = asset_data.download_count,
        created_at = asset_data.created_at,
        updated_at = asset_data.updated_at,
        browser_download_url = asset_data.browser_download_url,
      })
    end
  end

  return release
end

-- Find matching asset for system architecture
---@param release GitHubRelease
---@param system SystemArchitecture
---@return GitHubAsset
function M.find_matching_asset(release, system)
  if not release or not release.assets then
    error("release or release.assets is nil")
  end

  -- First try to find an exact match
  for _, asset in ipairs(release.assets) do
    if asset.name and asset.name:match(system.arch) and asset.name:match(system.os_name) then
      return asset
    end
  end

  -- If no exact match, try to find a compatible asset
  for _, asset in ipairs(release.assets) do
    if asset.name and asset.name:match(system.arch) then
      return asset
    end
  end

  -- If still no match, return the first non-checksum asset
  for _, asset in ipairs(release.assets) do
    if asset.name and not asset.name:match("%.sha256$") then
      return asset
    end
  end

  error("Could not find matching asset for system: " .. system.combination)
end

return M
