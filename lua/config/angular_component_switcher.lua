local function isAngularProject()
  -- Check for the presence of angular.json or angular.json in the root directory
  local angularJsonPath = vim.fn.globpath(vim.fn.getcwd(), "angular.json")
  return angularJsonPath ~= ""
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
