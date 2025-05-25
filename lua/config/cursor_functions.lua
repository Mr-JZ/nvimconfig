local function OpenVSCodeWithProjectAndCurrentFile()
  -- Find the project root by looking for a .git directory upwards
  local current_dir = vim.fn.getcwd()
  local project_root = nil
  local path_parts = vim.split(current_dir, "/")

  while #path_parts > 0 do
    local check_path = table.concat(path_parts, "/")
    if vim.fn.isdirectory(check_path .. "/.git") == 1 then
      project_root = check_path
      break
    end
    table.remove(path_parts)
  end

  local command
  if project_root then
    -- Get the absolute path of the current file
    local current_file = vim.fn.expand("%:p")
    local file_to_open = current_file

    -- Construct the command to open VS Code with project and file
    command = 'cursor "' .. project_root .. '" "' .. file_to_open .. '"'
  else
    -- No git folder found, just open the current file
    local current_file = vim.fn.expand("%:p") -- Get absolute path
    command = 'cursor "' .. current_file .. '"'
  end

  -- Notify the user about the command being executed
  vim.notify("Executing: " .. command, vim.log.levels.INFO)

  -- Simple shell execution (most compatible approach)
  vim.fn.jobstart({'sh', '-c', command}, {
    detach = true,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.schedule(function()
          vim.notify("Error executing command (exit code: " .. code .. ")", vim.log.levels.ERROR)
        end)
      end
    end
  })
end

-- Make the function globally accessible
_G.OpenVSCodeWithProjectAndCurrentFile = OpenVSCodeWithProjectAndCurrentFile

-- Map the function to the <leader>co shortcut
vim.keymap.set(
  "n",
  "<leader>co",
  "<cmd>lua OpenVSCodeWithProjectAndCurrentFile()<CR>",
  { desc = "Open VSCode with Project & Current File" }
)
