return {
  "https://gitlab.com/itaranto/plantuml.nvim",
  tag = "v1.5.0",
  config = function()
    require("plantuml").setup({
      renderer = {
        type = "image",
        options = {
          prog = "pqiv",
          dark_mode = true,
          format = "png", -- Allowed values: nil, 'png', 'svg'.
        },
      },
      render_on_write = true,
    })
  end,
}
