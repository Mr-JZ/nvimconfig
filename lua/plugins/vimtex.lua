return {
  "lervag/vimtex",
  enabled = false,
  -- I think it's a plugin for writing LaTeX documents.
  init = function()
      -- " This is necessary for VimTeX to load properly. The "indent" is optional.
      -- " Note that most plugin managers will do this automatically.
      -- filetype plugin indent on
      --
      -- " This enables Vim's and neovim's syntax-related features. Without this, some
      -- " VimTeX features will not work (see ":help vimtex-requirements" for more
      -- " info).
      -- syntax enable
      --
      -- " Viewer options: One may configure the viewer either by specifying a built-in
      -- " viewer method:
      -- let g:vimtex_view_method = 'zathura'
      --
      -- let g:vimtex_compiler_latexmk = {
      --     \ 'options' : [
      --     \   '-shell-escape',
      --     \   '-verbose',
      --     \   '-file-line-error',
      --     \   '-synctex=1',
      --     \   '-interaction=nonstopmode',
      --     \ ],
      --     \}
      -- " Or with a generic interface:
      -- " let g:vimtex_view_general_viewer = 'okular'
      -- " let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex' 
      --
      -- " Most VimTeX mappings rely on localleader and this can be changed with the
      -- " following line. The default is usually fine and is the symbol "\".
      -- let maplocalleader = ","
      vim.g.vimtex_view_general_viewer = "zathura"
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
      vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"
  end,
  keys = {
    { "<leader>tt", "<cmd>VimtexTocToggle<cr>" },
  },
}
