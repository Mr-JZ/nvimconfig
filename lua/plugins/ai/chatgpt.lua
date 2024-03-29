local home = vim.fn.expand("$HOME")
return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  config = function()
    require("chatgpt").setup({
      actions_paths = { home .. "/.config/nvim/lua/config/chatgpt-actions.json" },
      api_key_cmd = "cat " .. home .. "/.config/nvim/lua/plugins/ai/api_key.txt",
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
