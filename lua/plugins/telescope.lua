return  {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- add a keymap to browse plugin files
    -- stylua: ignore
    {
      "<leader>fp",
      function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
      desc = "Find Plugin File",
    },
  },
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("zotero")
    end,
    {
      'jmbuhr/telescope-zotero',
      dependencies = {
        { 'kkharji/sqlite.lua' },
      },
      -- default opts shown
      opts = {
        zotero_db_path = '~/Zotero/zotero.sqlite',
        better_bibtex_db_path = '~/Zotero/better-bibtex.sqlite',
        -- specify options for different filetypes
        -- locate_bib can be a string or a function
        ft = {
          quarto = {
            insert_key_formatter = function(citekey)
              return '@' .. citekey
            end,
            locate_bib = bib.locate_quarto_bib,
          },
          tex = {
            insert_key_formatter = function(citekey)
              return '\\cite{' .. citekey .. '}'
            end,
            locate_bib = bib.locate_tex_bib,
          },
          plaintex = {
            insert_key_formatter = function(citekey)
              return '\\cite{' .. citekey .. '}'
            end,
            locate_bib = bib.locate_tex_bib,
          },
          -- fallback for unlisted filetypes
          default = {
            insert_key_formatter = function(citekey)
              return '@' .. citekey
            end,
            locate_bib = bib.locate_quarto_bib,
          },
        },

            }
        },
    },
  },
  -- change some options
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
    },
    ensure_installed = {
      "bash",
      "html",
      "javascript",
      "json",
      "lua",
      "c",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "yaml",
    },
  },
}
