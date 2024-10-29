return {
  "https://gitlab.com/itaranto/plantuml.nvim",
  tag = "v1.5.0",
  enabled = false,
  opts = {
      renderer = {
        type = "image",
        options = {
          prog = "feh",
          dark_mode = true,
          format = nil, -- Allowed values: nil, 'png', 'svg'.
        },
      },
      render_on_write = true,
    }
}
