local function isAngularProject()
  -- First check: Look for angular.json in the root directory (standard Angular project)
  local angularJsonPath = vim.fn.globpath(vim.fn.getcwd(), "angular.json")
  if angularJsonPath ~= "" then
    return true
  end

  -- Second check: Look for angular.json in parent directories (monorepo structure)
  local currentFile = vim.api.nvim_buf_get_name(0)
  local currentDir = vim.fn.fnamemodify(currentFile, ":h")

  -- Check up to 5 parent directories for angular.json
  for i = 1, 5 do
    local checkPath = currentDir .. "/angular.json"
    if vim.fn.filereadable(checkPath) == 1 then
      return true
    end

    -- Move up one directory
    currentDir = vim.fn.fnamemodify(currentDir, ":h")
  end

  -- Third check: Look for component-like structure in the file path
  if currentFile:match("%.component%.ts$") or currentFile:match("%.component%.html$") then
    -- If the file follows Angular naming conventions, assume it's an Angular project
    return true
  end

  return false
end

local function getComponentName(filePath)
  -- Extract component name and directory from file path
  local directory, filename = filePath:match("(.+)/([^/]+)$")

  -- Extract the base component name (without extension)
  local baseName = filename:match("(.+)%.component%.[^.]+$")

  if not directory or not baseName then
    return nil
  end

  return directory .. "/" .. baseName
end

local function switchComponent(targetExt)
  local currentBuffer = vim.api.nvim_get_current_buf()
  local filePath = vim.api.nvim_buf_get_name(currentBuffer)

  if not filePath then
    vim.notify("Cannot get current file path.", vim.log.levels.ERROR)
    return
  end

  local componentBasePath = getComponentName(filePath)

  if not componentBasePath then
    vim.notify("Not an Angular component file.", vim.log.levels.ERROR)
    return
  end

  local newFilePath = componentBasePath .. ".component." .. targetExt

  -- Check if the file exists
  if vim.fn.filereadable(newFilePath) == 0 then
    vim.notify("Component file not found: " .. newFilePath, vim.log.levels.ERROR)
    return
  end

  vim.cmd("edit " .. vim.fn.fnameescape(newFilePath))
end

return {
  switchComponent = switchComponent,
  isAngularProject = isAngularProject,
}
