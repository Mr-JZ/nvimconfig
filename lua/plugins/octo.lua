return {
  "pwntester/octo.nvim",
  requires = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    -- OR 'ibhagwan/fzf-lua',
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>oo", "<cmd>Octo<cr>", desc = "Octo" },
    { "<leader>o", group = "octo", desc = "Octo" },
  },
  opts = {
      enable_builtin = true,
  },
}
