return {
  "leoluz/nvim-dap-go",
  ft = "go",
  enabled = false,
  dependencies = "mfussenegger/nvim-dap",
  config = function(_, opts)
    require("dap-go").setup(opts)
  end,
}
