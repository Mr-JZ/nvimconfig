return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = function()
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    local wk = require("which-key")

    wk.add({
      {"<leader>t", group = "Tabs"},
    })
  end,
}
