vim.g.airline_theme = 'codedark'

vim.cmd [[
  if exists('+termguicolors')
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
  endif

  filetype indent plugin on

  highlight Comment cterm=italic

  autocmd ColorScheme * highlight! link SignColumn LineNr

  syntax enable

  let g:codedark_italics=1

  colorscheme dark_plus
]]
