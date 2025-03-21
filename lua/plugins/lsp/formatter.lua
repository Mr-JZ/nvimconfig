return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  enabled = true,
  cmd = { "ConformInfo" },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        css = { "eslint_d" },
        html = { "eslint_d" },
        json = { "eslint_d" },
        yaml = { "eslint_d" },
        markdown = { "eslint_d" },
        lua = { "stylua" },
        python = { "isort", "black" },
        go = { "gofumpt", "goimports-reviser", "golines" },
        nix = { "nil" },
      },
      format_on_save = {
        lsp_fallback = true,
      },
    })
  end,
}
