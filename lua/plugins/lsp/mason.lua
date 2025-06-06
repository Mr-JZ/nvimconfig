return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "angularls",
        "html",
        "cssls",
        "tailwindcss",
        "graphql",
        "emmet_ls",
        "gopls",
        "astro",
        "templ",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_enable = {
        exclude = {
          "ts_ls",
        },
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "eslint_d",
        "prettierd", -- prettier formatter
        "gofumpt",
        "goimports-reviser",
        "golines",
      },
      automatic_installation = false,
    })
  end,
}
