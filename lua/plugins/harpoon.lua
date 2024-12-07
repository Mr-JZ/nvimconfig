return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    
    harpoon:setup({
      global_settings = {
        save_on_toggle = true,
      }
    })

    -- Add keymaps
    vim.keymap.set("n", "A-h", function()
      harpoon:list():add()
    end, { desc = "Harpoon: add file" })

    vim.keymap.set("n", "<leader>H", function()
      harpoon.ui:toggle_quick_menu()
    end, { desc = "Harpoon: toggle quick menu" })

    -- Optional: Add navigation keymaps
       vim.keymap.set("n", "<A-j>", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<A-k>", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<A-l>", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<A-;>", function() harpoon:list():select(4) end)
  end,
}
