return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  enabled = true,
  cmd = { "ConformInfo" },
  config = function()
    ---@alias Formatter "prettier" | "eslint_d" | string
    local formatter = "eslint_d"

    require("conform").setup({
      formatters_by_ft = {
        typescript = { formatter },
        javascriptreact = { formatter },
        typescriptreact = { formatter },
        svelte = { formatter },
        css = { formatter },
        html = { formatter },
        json = { formatter },
        yaml = { formatter },
        markdown = { formatter },
        astro = { formatter },
        lua = { "stylua" },
        python = { "isort", "black" },
        go = { "gofumpt", "goimports-reviser", "golines" },
        nix = { "nixfmt" },
      },
      format_on_save = {
        lsp_fallback = true,
      },
    })
  end,
}
