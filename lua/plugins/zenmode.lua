return {
  "folke/zen-mode.nvim",
  event = "VeryLazy",
  opts = {
    window = {
      backdrop = 0.95,
      width = 160, -- width of the Zen window
      height = 0.5, -- height of the Zen window
      options = {
        signcolumn = "no", -- disable signcolumn
        number = true, -- disable number column
        relativenumber = true, -- disable relative numbers
        -- cursorline = false, -- disable cursorline
        -- cursorcolumn = false, -- disable cursor column
        -- foldcolumn = "0", -- disable fold column
        -- list = false, -- disable whitespace characters
      },
      position = "center",
    },
    plugins = {
      -- disable some global vim options (vim.o...)
      options = {
        enabled = true,
        ruler = false, -- disables the ruler text in the cmd line area
        showcmd = false, -- disables the command in the last line of the screen
        -- you may turn on/off statusline in zen mode by setting 'laststatus'
        -- statusline will be shown only if 'laststatus' == 3
        laststatus = 0, -- turn off the statusline in zen mode
      },
      twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
      gitsigns = { enabled = false }, -- disables git signs
      tmux = { enabled = true }, -- disables the tmux statusline
      wezterm = {
        enabled = false,
        font = "+20", -- (10% increase per step)
      },
      kitty = {
        enabled = true,
        font = "+6", -- (10% increase per step)
      },
    },
  },
}
