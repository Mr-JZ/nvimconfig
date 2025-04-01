return {
  "folke/trouble.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  keys = {
    {
      "<F3>",
      function()
        local trouble = require("trouble")
        if next(vim.lsp.get_clients({ bufnr = 0 })) == nil then
          vim.notify("No LSP clients are attached to this buffer", vim.log.levels.WARN)
          return
        end
        trouble.toggle("diagnostics")
      end,
      mode = { "n", "v" },
      desc = "Toggle Trouble Diagnostics",
    },
  },
  config = function()
    require("trouble").setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    })
  end,
}
