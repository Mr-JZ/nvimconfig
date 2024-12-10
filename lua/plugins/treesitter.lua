return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    }
    -- TODO: add treesitter movement: that means you can move to a function definition with ]m or select a function with [m
}
