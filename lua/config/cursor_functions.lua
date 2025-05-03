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

  if project_root then
    -- Construct the relative path of the current file from the project root
    local current_file = vim.fn.expand("%")
    local relative_path = vim.fn.fnamemodify(current_file, ":" .. #project_root + 2 .. ":.")

    -- Construct the command to open VS Code
    local command = 'cursor "' .. project_root .. '" "' .. relative_path .. '"'

    -- Execute the command (you might need to adjust this based on your OS)
    vim.fn.system(command .. " &") -- The '&' sends it to the background
  else
    vim.notify("Could not find project root (no .git directory found upwards).", vim.log.levels.WARN)
  end
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
