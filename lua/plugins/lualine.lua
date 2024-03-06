return {
  "nvim-lualine/lualine.nvim",
  enabled = false,
  event = "VeryLazy",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, "😄")
  end,
}
