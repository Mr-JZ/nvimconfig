-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.options")
require("config.keymaps")
require("config.hsl_to_hex")
require("config.hsl_commands").setup()
require("config.lazy")

-- TODO: add add mini.nvim to your packages https://www.youtube.com/watch?v=cNK5kYJ7mrs
