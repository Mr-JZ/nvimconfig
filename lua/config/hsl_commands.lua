local M = {}

-- Import the hslToHex function
local hslToHex = require("config.hsl_to_hex").hslToHex

-- Function to convert HSL to Hex in visual selection
function M.setup()
  -- Create the command that works on visual selection
  vim.api.nvim_create_user_command("HslToHex", function(opts)
    -- Get the selected lines
    local start_line = opts.line1
    local end_line = opts.line2
    
    -- Store just the hex values for clipboard
    local hex_values = {}
    
    -- Process each selected line
    for i = start_line, end_line do
      local line = vim.api.nvim_buf_get_lines(0, i-1, i, false)[1]
      
      -- Find HSL patterns in the line and convert them (without replacing)
      line:gsub("(%d+%.?%d*)%s+(%d+%.?%d*)%%%s+(%d+%.?%d*)%%", function(h, s, l)
        local hsl_string = h .. " " .. s .. "% " .. l .. "%"
        local hex_value = hslToHex(hsl_string)
        table.insert(hex_values, hex_value)
        return hsl_string -- Return original string (no replacement)
      end)
    end
    
    -- Join just the hex values for clipboard
    local result = ""
    if #hex_values > 0 then
      result = table.concat(hex_values, "\n")
    
      -- Copy to clipboard (+ register) and default register (")
      vim.fn.setreg("+", result)
      vim.fn.setreg("\"", result)
      
      -- Notify user
      vim.notify("Copied hex values to clipboard: " .. result, vim.log.levels.INFO)
    else
      vim.notify("No HSL values found to convert", vim.log.levels.WARN)
    end
  end, {range = true})
  
  -- Create a key mapping for visual mode
  vim.api.nvim_set_keymap('v', '<leader>hh', ':HslToHex<CR>', {noremap = true, silent = true})
end

return M

