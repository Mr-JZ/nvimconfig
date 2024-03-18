{
  "jghauser/papis.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("papis").setup({
    -- Your configuration goes here
    })
  end,
}
