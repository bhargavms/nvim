return {
  name = "dummy-fail",
  description = "Test tool that prints lorem ipsum and fails",
  install_cmd = [[
    echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit." && \
    echo "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." && \
    echo "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris." && \
    echo "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum." && \
    echo "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia." && \
    sleep 1 && \
    echo "Starting installation..." && \
    sleep 1 && \
    echo "Downloading package..." && \
    sleep 1 && \
    echo "Extracting files..." && \
    sleep 1 && \
    echo "ERROR: Something went terribly wrong!" && \
    exit 1
  ]],
  update_cmd = [[
    echo "Checking for updates..." && \
    sleep 1 && \
    echo "Fetching latest version..." && \
    sleep 1 && \
    echo "ERROR: Update failed spectacularly!" && \
    exit 1
  ]],
  is_installed = function()
    return false
  end,
}
