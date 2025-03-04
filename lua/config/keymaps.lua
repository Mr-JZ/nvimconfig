-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open explorer" }) -- open explorer
-- Keep selection after indenting
keymap.set("v", "<", "<gv", { desc = "Indent left and keep selection" })
keymap.set("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- window management
--
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Reload configuration
keymap.set("n", "<leader>sr", "<cmd>lua require('lazy').sync()<CR>", { desc = "Sync and reload plugins" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Toggle invisible characters
vim.keymap.set(
  "n",
  "<leader>li",
  ":set list!<CR>",
  { noremap = true, silent = true, desc = "Toggle invisible characters" }
)

-- Disable F1 Help key
keymap.set({ "n", "i" }, "<F1>", "<Nop>", { noremap = true, silent = true, desc = "Disable help key" })

-- Toggle relative line numbers
keymap.set("n", "<leader>lr", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers" })
