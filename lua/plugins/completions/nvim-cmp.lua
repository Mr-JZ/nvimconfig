return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- "zbirenbaum/copilot-cmp",
    "hrsh7th/cmp-emoji",
    "Exafunction/codeium.nvim",
    {
      "MattiasMTS/cmp-dbee",
      dependencies = {
        {"kndndrj/nvim-dbee"}
      },
      ft = "sql", -- optional but good to have
      opts = {}, -- needed
    },
  },
  opts = function(_, opts)
    -- table.insert(opts.sources, 1, {
    --   name = "copilot",
    --   group_index = 1,
    --   priority = 50,
    -- })
    local cmp = require("cmp")
    require("luasnip.loaders.from_vscode").lazy_load()
    -- require("copilot").setup({})

    cmp.setup({
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
        -- TODO: implement ultisnips
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-y>"] = cmp.mapping.completion(),
        ["<C-a>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        -- { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
        { name = "supermaven" },
        { name = "cmp-dbee" },
        { name = "buffer" },
      }),
    })
  end,
}
