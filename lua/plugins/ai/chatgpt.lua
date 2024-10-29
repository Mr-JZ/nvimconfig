local home = vim.fn.expand("$HOME")
return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  opts = {
      actions_paths = { home .. "/.config/nvim/lua/config/chatgpt-actions.json" },
      api_key_cmd = "cat " .. home .. "/.config/nvim/lua/plugins/ai/api_key.txt",
      openai_params = {
        model = "gpt-4o", -- Specify the newest model here
        max_tokens = 6024
      },
      openai_edit_params = {
            model = "gpt-4o",
            frequency_penalty = 0,
            presence_penalty = 0,
            temperature = 0,
            top_p = 1,
            n = 1,
      },
  },
  keys = {
    { "<leader>tc", "<cmd>ChatGPT<cr>", desc = "ChatGPT" },
    { "<leader>te", "<cmd>ChatGPTEditWithInstructions<cr>", mode = { "n", "v" }, desc = "ChatGPT Edit with Instructions" },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
