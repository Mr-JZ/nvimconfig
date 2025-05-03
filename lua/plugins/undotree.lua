return {
  "mbbill/undotree",
  enabled = true,
  config = function()
    vim.keymap.set("n", "<F5>", vim.cmd.UndotreeToggle, { desc = "Toggle undo tree" })
  end,
}
