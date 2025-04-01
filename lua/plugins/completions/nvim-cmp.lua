return {
  "hrsh7th/nvim-cmp",
  enabled = false,
  dependencies = {
    {
      "MattiasMTS/cmp-dbee",
      dependencies = {
        { "kndndrj/nvim-dbee" },
      },
      ft = "sql", -- optional but good to have
      opts = {}, -- needed
    },
  },
  opts = function(_, opts)
    local cmp = require("cmp")
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
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
        -- ["<C-y>"] = cmp.mapping.completion(),
        ["<C-a>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = "cmp-dbee" },
        -- { name = "supermaven" },
        { name = "luasnip" }, -- For luasnip users.
        { name = "buffer" },
        { name = "nvim_lsp" },
      }),
    })
  end,
}
