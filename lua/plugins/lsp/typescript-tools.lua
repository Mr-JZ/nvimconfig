return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {},
  config = function()
    local api = require("typescript-tools.api")
    require("typescript-tools").setup({
      settings = {
        -- Your tsserver settings here
      },
      on_attach = function(client, bufnr)
        -- Auto-remove unused imports on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.cmd("TSToolsRemoveUnusedImports")
          end,
        })

        -- Set up keymaps
        vim.keymap.set(
          "n",
          "<leader>toi",
          "<cmd>TSToolsOrganizeImports<cr>",
          { buffer = true, desc = "Organize Imports" }
        )
        vim.keymap.set("n", "<leader>tsi", "<cmd>TSToolsSortImports<cr>", { buffer = true, desc = "Sort Imports" })
        vim.keymap.set(
          "n",
          "<leader>tri",
          "<cmd>TSToolsRemoveUnusedImports<cr>",
          { buffer = true, desc = "Remove Unused Imports" }
        )
        vim.keymap.set("n", "<leader>tru", "<cmd>TSToolsRemoveUnused<cr>", { buffer = true, desc = "Remove Unused" })
        vim.keymap.set(
          "n",
          "<leader>tmi",
          "<cmd>TSToolsAddMissingImports<cr>",
          { buffer = true, desc = "Add Missing Imports" }
        )
        vim.keymap.set("n", "<leader>tfa", "<cmd>TSToolsFixAll<cr>", { buffer = true, desc = "Fix All" })
        vim.keymap.set(
          "n",
          "<leader>tsd",
          "<cmd>TSToolsGoToSourceDefinition<cr>",
          { buffer = true, desc = "Go To Source Definition" }
        )
        vim.keymap.set(
          "n",
          "<leader>tfr",
          "<cmd>TSToolsFileReferences<cr>",
          { buffer = true, desc = "File References" }
        )
      end,
    })
  end,
}
