return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  enabled = true,
  cmd = { "ConformInfo" },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        go = { "gofumpt", "goimports-reviser", "golines" },
      },
      format_on_save = {
        lsp_fallback = true,
      },
    })
  end,
}
