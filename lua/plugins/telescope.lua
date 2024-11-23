return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-ui-select.nvim" },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
    -- { "nvim-telescope/telescope-dap.nvim" },
    -- {
    --   "jmbuhr/telescope-zotero.nvim",
    --   enabled = true,
    --   dev = false,
    --   dependencies = {
    --     { "kkharji/sqlite.lua" },
    --   },
    --   config = function()
    --     vim.keymap.set("n", "<leader>fz", ":Telescope zotero<cr>", { desc = "[z]otero" })
    --   end,
    -- },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    {
      "danielfalk/smart-open.nvim",
      branch = "0.2.x",
      dependencies = {
        "kkharji/sqlite.lua",
        { "nvim-telescope/telescope-fzy-native.nvim" },
      },
    },

    "AckslD/nvim-neoclip.lua",
    "danielvolchek/tailiscope.nvim",
    "debugloop/telescope-undo.nvim",
    -- "natecraddock/telescope-zf-native.nvim",
    "piersolenski/telescope-import.nvim",
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
    "vuki656/package-info.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local previewers = require("telescope.previewers")

    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")

    -- or create your custom action
    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        trouble.toggle("quickfix")
      end,
    })
    local new_maker = function(filepath, bufnr, opts)
      opts = opts or {}
      filepath = vim.fn.expand(filepath)
      vim.loop.fs_stat(filepath, function(_, stat)
        if not stat then
          return
        end
        if stat.size > 100000 then
          return
        else
          previewers.buffer_previewer_maker(filepath, bufnr, opts)
        end
      end)
    end
    telescope.setup({
      defaults = {
        buffer_previewer_maker = new_maker,
        file_ignore_patterns = {
          "node_modules",
          "%_files/*.html",
          "%_cache",
          ".git/",
          "site_libs",
          ".venv",
        },
        layout_strategy = "flex",
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
            ["<esc>"] = actions.close,
            ["<c-j>"] = actions.move_selection_next,
            ["<c-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-t>"] = trouble_telescope.open,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = false,
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--glob",
            "!.git/*",
            "--glob",
            "!**/.Rpro.user/*",
            "--glob",
            "!_site/*",
            "--glob",
            "!docs/**/*.html",
            "-L",
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
      -- smart_open = {
      --   cwd_only = true,
      --   filename_first = true,
      -- },
      },
    })
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("import")
    telescope.load_extension("live_grep_args")
    telescope.load_extension("neoclip")
    telescope.load_extension("notify")
    telescope.load_extension("package_info")
    -- telescope.load_extension("smart_open")
    telescope.load_extension("tailiscope")
    telescope.load_extension("undo")
    -- telescope.load_extension("dap")
    -- telescope.load_extension("zotero")
  end,
}
