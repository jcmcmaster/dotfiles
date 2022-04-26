vim.cmd [[
  if exists('+termguicolors')
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
  endif

  highlight Comment cterm=italic

  autocmd ColorScheme * highlight! link SignColumn LineNr

  syntax enable

  colorscheme codedark

  let g:airline_theme='codedark'
]]
