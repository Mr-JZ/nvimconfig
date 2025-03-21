-- Function to find the globals.css file
local function find_globals_css()
  local search_dirs = {
    ".", -- Current directory
    "styles", -- A common directory name
    "css",
    "assets",
    "src",
    "app",
    "client",
    "src/styles",
    "src/app",
    "src/css",
    "app/styles",
    "public/styles",
    "themes",
    -- Add more directories if needed,  e.g., "~/path/to/your/project"
  }

  local possible_filenames = {
    "globals.css",
    "global.css",
    "theme.css",
    "colors.css",
    "variables.css",
    "tokens.css",
    "tailwind.css"
  }

  for _, dir in ipairs(search_dirs) do
    for _, filename in ipairs(possible_filenames) do
      local filepath = dir .. "/" .. filename
      local file = io.open(filepath, "r")
      if file then
        file:close()
        return filepath
      end
    end
  end

  -- Allow user to input a path if not found
  print("No CSS file found in search directories.")
  print("Enter the full path to your CSS file:")
  local user_path = vim.fn.input("Path: ")
  if user_path and user_path ~= "" then
    local file = io.open(user_path, "r")
    if file then
      file:close()
      return user_path
    end
  end

  return nil
end

-- Function to extract colors from CSS using regex
local function extract_colors_from_css(filename)
  local file = io.open(filename, "r")
  if not file then
    return nil, "Could not open file: " .. filename
  end

  local content = file:read("*a")
  file:close()

  local colors = {}
  local count = 0

  -- Check if this is a Tailwind CSS file
  local is_tailwind = content:match("@tailwind") ~= nil

  if is_tailwind then
    print("Detected Tailwind CSS format")
  end

  -- Regex to find CSS variables with their values
  local variable_pattern = "%-%-([%w%-]+):%s*([^;]+)"

  -- Extract all variables regardless of format
  for name, value in content:gmatch(variable_pattern) do
    if name and value then
      -- Trim whitespace
      value = value:gsub("^%s*(.-)%s*$", "%1")
      
      -- Check if it's an HSL color value (space-separated)
      -- Format like: 0 0% 100%
      if value:match("^%d+%s+%d+%%%s+%d+%%$") then
        local h, s, l = value:match("(%d+)%s+(%d+)%%%s+(%d+)%%")
        if h and s and l then
          colors[name] = {
            type = "color",
            format = "hsl",
            h = tonumber(h),
            s = tonumber(s) / 100, -- Convert to 0-1 range for Figma
            l = tonumber(l) / 100, -- Convert to 0-1 range for Figma
            original = value,
            display = "hsl(" .. h .. ", " .. s .. "%, " .. l .. "%)"
          }
          count = count + 1
        end
      -- Handle var() references
      elseif value:match("^var%(-%-[%w%-]+%)$") then
        local ref_var = value:match("var%(-%-([%w%-]+)%)")
        if ref_var then
          colors[name] = {
            type = "reference",
            reference = ref_var,
            original = value
          }
          count = count + 1
        end
      end
    end
  end

  if count == 0 then
    return {}, "No colors found in CSS file."
  end

  -- Resolve references
  for name, color in pairs(colors) do
    if color.type == "reference" then
      local ref = colors[color.reference]
      if ref and ref.type == "color" then
        colors[name] = {
          type = "color",
          format = ref.format,
          h = ref.h,
          s = ref.s,
          l = ref.l,
          original = ref.original,
          display = ref.display
        }
      end
    end
  end

  return colors, nil
end

-- Function to convert colors to JSON in Figma-compatible format
local function colors_to_json(colors)
  local json = '{\n  "variables": ['
  local first = true

  -- Sort the colors by name for better organization
  local sorted_colors = {}
  for name, color in pairs(colors) do
    if color.type == "color" then
      table.insert(sorted_colors, { name = name, color = color })
    end
  end
  
  table.sort(sorted_colors, function(a, b)
    return a.name < b.name
  end)

  for _, item in ipairs(sorted_colors) do
    if not first then
      json = json .. ",\n"
    end
    
    -- Format for Figma Variables API
    json = json .. '\n    {\n'
    json = json .. '      "name": "' .. item.name .. '",\n'
    json = json .. '      "type": "COLOR",\n'
    json = json .. '      "value": {\n'
    json = json .. '        "r": ' .. hsl_to_rgb(item.color.h, item.color.s, item.color.l, 'r') .. ',\n'
    json = json .. '        "g": ' .. hsl_to_rgb(item.color.h, item.color.s, item.color.l, 'g') .. ',\n'
    json = json .. '        "b": ' .. hsl_to_rgb(item.color.h, item.color.s, item.color.l, 'b') .. ',\n'
    json = json .. '        "a": 1\n'
    json = json .. '      },\n'
    json = json .. '      "description": "' .. item.color.display .. '"\n'
    json = json .. '    }'
    
    first = false
  end
  json = json .. "\n  ]\n}"
  return json
end

-- HSL to RGB conversion function
function hsl_to_rgb(h, s, l, component)
  h = h / 360 -- Convert to 0-1 range
  
  local r, g, b
  
  if s == 0 then
    r, g, b = l, l, l -- Achromatic (gray)
  else
    local function hue_to_rgb(p, q, t)
      if t < 0 then t = t + 1 end
      if t > 1 then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end
    
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    
    r = hue_to_rgb(p, q, h + 1/3)
    g = hue_to_rgb(p, q, h)
    b = hue_to_rgb(p, q, h - 1/3)
  end
  
  -- Return the requested component
  if component == 'r' then return r end
  if component == 'g' then return g end
  if component == 'b' then return b end
  
  -- Return all components as a table if no specific component requested
  return { r = r, g = g, b = b }
end

-- Function to copy to clipboard using wl-copy (or fallback)
local function copy_to_clipboard(text)
  local handle = io.popen("wl-copy", "w") --For wayland
  if handle then
    handle:write(text)
    handle:close()
    return true, "Copied to clipboard using wl-copy"
  else
    handle = io.popen("xclip -selection clipboard", "w") -- Check for xclip
    if handle then
      handle:write(text)
      handle:close()
      return true, "Copied to clipboard using xclip"
    else
      handle = io.popen("pbcopy", "w") -- Check for pbcopy (macOS)
      if handle then
        handle:write(text)
        handle:close()
        return true, "Copied to clipboard using pbcopy"
      else
        return false, "wl-copy, xclip, and pbcopy not found. Please install one of these clipboard utilities."
      end
    end
  end
end

-- Enhanced function to detect if the CSS has light/dark mode
local function detect_color_modes(content)
  -- Common patterns for light mode
  local light_patterns = {
    ":root%s*{",                      -- Standard CSS variables
    "%.light%s*{",                    -- Light class
    "html%[data%-theme%=\"light\"%]", -- HTML data attribute (common in frameworks)
    "[^%S\n]*light%-theme%s*{",       -- Light theme class
    "body%.light%s*{",                -- Body with light class
  }
  
  -- Common patterns for dark mode
  local dark_patterns = {
    "%.dark%s*{",                    -- Dark class
    "@media%s*%(prefers%-color%-scheme:%s*dark%)%s*{", -- Media query for dark mode
    "html%[data%-theme%=\"dark\"%]", -- HTML data attribute (common in frameworks)
    "[^%S\n]*dark%-theme%s*{",       -- Dark theme class
    "body%.dark%s*{",                -- Body with dark class
  }
  
  -- Check for light mode patterns
  local has_light = false
  for _, pattern in ipairs(light_patterns) do
    if content:match(pattern) then
      has_light = true
      break
    end
  end
  
  -- Check for dark mode patterns
  local has_dark = false
  for _, pattern in ipairs(dark_patterns) do
    if content:match(pattern) then
      has_dark = true
      break
    end
  end
  
  -- Also detect system mode (prefers-color-scheme)
  local has_system = content:match("@media%s*%(prefers%-color%-scheme:") ~= nil
  
  return has_light, has_dark, has_system
end

-- Function to extract colors based on selected mode
local function extract_colors_by_mode(filename, mode)
  local file = io.open(filename, "r")
  if not file then
    return nil, "Could not open file: " .. filename
  end

  local content = file:read("*a")
  file:close()

  local colors = {}
  local count = 0
  local section_pattern, section
  
  -- Define patterns for each mode
  if mode == "light" then
    section_pattern = {
      ":root%s*{(.-)%s*%.dark",  -- Extract from :root to .dark
      ":root%s*{(.-)}%s*%.dark", -- Alternative pattern
      ":root%s*{(.-)}",          -- Just extract :root if no .dark
    }
  elseif mode == "dark" then
    section_pattern = {
      "%.dark%s*{(.-)}", -- Extract dark mode section
    }
  elseif mode == "system" then
    -- For system mode, we'll need both light and dark
    local light_colors, _ = extract_colors_by_mode(filename, "light")
    local dark_colors, _ = extract_colors_by_mode(filename, "dark")
    
    -- Combine them with a modifier to indicate which is which
    if light_colors then
      for name, color in pairs(light_colors) do
        colors["light_" .. name] = color
        count = count + 1
      end
    end
    
    if dark_colors then
      for name, color in pairs(dark_colors) do
        colors["dark_" .. name] = color
        count = count + 1
      end
    end
    
    if count == 0 then
      return {}, "No colors found in system mode."
    end
    
    return colors, nil
  else
    -- Extract all colors if no specific mode is selected
    return extract_colors_from_css(filename)
  end

  -- Try each pattern until we find a match
  for _, pattern in ipairs(section_pattern) do
    section = content:match(pattern)
    if section then
      break
    end
  end
  
  if not section then
    return {}, "No " .. mode .. " mode section found in CSS file."
  end

  -- Regex to find CSS variables with their values in the selected section
  local variable_pattern = "%-%-([%w%-]+):%s*([^;]+)"

  -- Extract all variables in the section
  for name, value in section:gmatch(variable_pattern) do
    if name and value then
      -- Trim whitespace
      value = value:gsub("^%s*(.-)%s*$", "%1")
      
      -- Check if it's an HSL color value (space-separated)
      if value:match("^%d+%s+%d+%%%s+%d+%%$") then
        local h, s, l = value:match("(%d+)%s+(%d+)%%%s+(%d+)%%")
        if h and s and l then
          colors[name] = {
            type = "color",
            format = "hsl",
            h = tonumber(h),
            s = tonumber(s) / 100, -- Convert to 0-1 range for Figma
            l = tonumber(l) / 100, -- Convert to 0-1 range for Figma
            original = value,
            display = "hsl(" .. h .. ", " .. s .. "%, " .. l .. "%)"
          }
          count = count + 1
        end
      -- Handle var() references
      elseif value:match("^var%(-%-[%w%-]+%)$") then
        local ref_var = value:match("var%(-%-([%w%-]+)%)")
        if ref_var then
          colors[name] = {
            type = "reference",
            reference = ref_var,
            original = value
          }
          count = count + 1
        end
      end
    end
  end

  -- Resolve references
  for name, color in pairs(colors) do
    if color and color.type == "reference" then
      local ref = colors[color.reference]
      if ref and ref.type == "color" then
        colors[name] = {
          type = "color",
          format = ref.format,
          h = ref.h,
          s = ref.s,
          l = ref.l,
          original = ref.original,
          display = ref.display
        }
      end
    end
  end

  if count == 0 then
    return {}, "No colors found in " .. mode .. " mode section."
  end

  return colors, nil
end

-- Function to create a Telescope color preview
local function create_color_preview(mode, colors)
  if not colors or vim.tbl_isempty(colors) then
    return "No colors found"
  end
  
  local preview = mode .. " Mode Colors:\n\n"
  local count = 0
  
  for name, color in pairs(colors) do
    if color.type == "color" then
      -- Add colored preview box
      preview = preview .. name .. ": " .. color.display .. "\n"
      count = count + 1
      if count >= 15 then
        preview = preview .. "\n... and " .. (vim.tbl_count(colors) - 15) .. " more colors"
        break
      end
    end
  end
  
  return preview
end

-- Main function to run the script
local function css_to_figma()
  local css_file = find_globals_css()
  if not css_file then
    print("No CSS file found in any of the search directories.")
    return
  end

  -- Read the file to detect color modes
  local file = io.open(css_file, "r")
  if not file then
    print("Could not open file: " .. css_file)
    return
  end
  local content = file:read("*a")
  file:close()

  local has_light, has_dark, has_system = detect_color_modes(content)
  
  -- Prepare mode options
  local modes = {
    { text = "All Colors", value = "all", found = true }
  }
  
  if has_light then
    table.insert(modes, { text = "Light Mode", value = "light", found = true })
  end
  
  if has_dark then
    table.insert(modes, { text = "Dark Mode", value = "dark", found = true })
  end
  
  if has_system then
    table.insert(modes, { text = "System Mode", value = "system", found = true })
  end

  -- If multiple modes are detected and Telescope is available, use it
  if #modes > 1 and pcall(require, "telescope") then
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local previewers = require("telescope.previewers")
    
    -- Pre-calculate colors for preview
    local mode_colors = {}
    for _, mode in ipairs(modes) do
      local colors, _ = extract_colors_by_mode(css_file, mode.value)
      mode_colors[mode.value] = colors or {}
    end
    
    -- Create proper previewer using Telescope's API
    local color_previewer = previewers.new_buffer_previewer({
      title = "Color Preview",
      define_preview = function(self, entry, status)
        local preview_text = create_color_preview(entry.text, mode_colors[entry.value])
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(preview_text, "\n"))
        
        -- Apply syntax highlighting for better visibility
        vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "markdown")
      end
    })

    pickers.new({}, {
      prompt_title = "Select Color Mode for Figma Export",
      finder = finders.new_table({
        results = modes,
        entry_maker = function(entry)
          return {
            value = entry.value,
            text = entry.text,
            display = entry.text .. (entry.found and " (Detected)" or ""),
            ordinal = entry.text,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = color_previewer,
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          local colors, err
          if selection.value == "all" then
            colors, err = extract_colors_from_css(css_file)
          else
            colors, err = extract_colors_by_mode(css_file, selection.value)
          end

          if err then
            print("Error: " .. err)
            return
          end

          if not colors or vim.tbl_isempty(colors) then
            print("No colors found in " .. css_file .. " for " .. selection.text)
            return
          end

          -- Print summary of found colors
          print("Found " .. vim.tbl_count(colors) .. " colors in " .. selection.text)

          local json_output = colors_to_json(colors)

          -- Create a temporary buffer to show the extracted colors
          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(json_output, "\n"))
          vim.api.nvim_buf_set_option(buf, "filetype", "json")
          vim.api.nvim_command("vsplit")
          vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), buf)
          vim.api.nvim_buf_set_name(buf, "Figma Colors - " .. selection.text)

          local success, msg = copy_to_clipboard(json_output)
          if success then
            print(msg .. ". You can now paste the JSON into your Figma Variables Importer.")
          else
            print(msg .. "\n\nPlease copy the JSON from the buffer manually and paste it into Figma.")
          end
        end)
        return true
      end,
    }):find()
  else
    -- If only one mode or Telescope is not available, proceed with the original function
    if not pcall(require, "telescope") and #modes > 1 then
      print("Note: Install telescope.nvim for better mode selection experience. Processing all colors.")
    elseif #modes == 1 then
      print("Only one color mode detected. Processing all colors.")
    end
    
    local colors, err = extract_colors_from_css(css_file)
    if err then
      print("Error: " .. err)
      return
    end

    if not colors or vim.tbl_isempty(colors) then
      print("No colors found in " .. css_file)
      return
    end

    -- Print summary of found colors
    print("Found " .. vim.tbl_count(colors) .. " colors in " .. css_file)

    local json_output = colors_to_json(colors)

    -- Create a temporary buffer to show the extracted colors
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(json_output, "\n"))
    vim.api.nvim_buf_set_option(buf, "filetype", "json")
    vim.api.nvim_command("vsplit")
    vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), buf)
    vim.api.nvim_buf_set_name(buf, "Figma Colors")

    local success, msg = copy_to_clipboard(json_output)
    if success then
      print(msg .. ". You can now paste the JSON into your Figma Variables Importer.")
    else
      print(msg .. "\n\nPlease copy the JSON from the buffer manually and paste it into Figma.")
    end
  end
end

-- Register the command with Neovim
vim.api.nvim_create_user_command("CSStoFigma", css_to_figma, {
  desc = "Convert CSS colors to Figma JSON and copy to clipboard",
})

-- Check if Telescope is available and print a message if not
if not pcall(require, "telescope") then
  vim.api.nvim_create_autocmd("User", {
    pattern = "CSStoFigmaLoaded",
    callback = function()
      vim.notify("Note: Install telescope.nvim for better mode selection experience", vim.log.levels.INFO)
    end,
  })
end

-- Emit event that the plugin is loaded
vim.api.nvim_exec_autocmds("User", { pattern = "CSStoFigmaLoaded" })
