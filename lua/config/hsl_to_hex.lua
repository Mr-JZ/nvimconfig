local M = {}

function M.hslToHex(hslString)
  -- Parse HSL values from string like "0 0% 100%" or values with decimals like "240 3.8% 46.1%"
  local h, s, l = hslString:match("(%d+%.?%d*)%s+(%d+%.?%d*)%%%s+(%d+%.?%d*)%%")
  h, s, l = tonumber(h), tonumber(s) / 100, tonumber(l) / 100

  -- HSL to RGB conversion
  local r, g, b

  if s == 0 then
    -- Achromatic (gray)
    r, g, b = l, l, l
  else
    local function hue2rgb(p, q, t)
      if t < 0 then
        t = t + 1
      end
      if t > 1 then
        t = t - 1
      end
      if t < 1 / 6 then
        return p + (q - p) * 6 * t
      end
      if t < 1 / 2 then
        return q
      end
      if t < 2 / 3 then
        return p + (q - p) * (2 / 3 - t) * 6
      end
      return p
    end

    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q

    r = hue2rgb(p, q, (h / 360) + 1 / 3)
    g = hue2rgb(p, q, h / 360)
    b = hue2rgb(p, q, (h / 360) - 1 / 3)
  end

  -- Convert RGB to hex
  r, g, b = math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
  return string.format("#%02X%02X%02X", r, g, b)
end

return M
