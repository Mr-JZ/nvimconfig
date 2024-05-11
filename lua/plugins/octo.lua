return {
  "pwntester/octo.nvim",
  requires = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    -- OR 'ibhagwan/fzf-lua',
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<space>o", "<cmd>Octo<cr>", desc = "Octo" },
  },
  config = function()
    require("octo").setup({
      enable_builtin = true,
    })
  end,
}
