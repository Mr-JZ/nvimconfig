return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  enabled = true,
  cmd = { "ConformInfo" },
  config = function()
    ---@alias Formatter "prettier" | "eslint_d" | string
    -- Dynamically select formatter based on presence of .prettierrc.json in project root
    local cwd = vim.loop.cwd()
    local prettier_config = cwd .. "/.prettierrc.json"
    local formatter
    if vim.loop.fs_stat(prettier_config) then
      formatter = "prettierd"
    else
      formatter = "eslint_d"
    end

    require("conform").setup({
      formatters_by_ft = {
        typescript = { formatter },
        htmlangular = { formatter },
        javascriptreact = { formatter },
        typescriptreact = { formatter },
        svelte = { formatter },
        css = { formatter },
        scss = { formatter },
        html = { formatter },
        json = { formatter },
        jsonc = { formatter },
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
