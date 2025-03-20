return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  enabled = true,
  cmd = { "ConformInfo" },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        typescript = { "eslint_d" },
        javascriptreact = { "eslint" },
        typescriptreact = { "eslint" },
        svelte = { "eslint" },
        css = { "eslint" },
        html = { "eslint" },
        json = { "eslint" },
        yaml = { "eslint" },
        markdown = { "eslint" },
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
