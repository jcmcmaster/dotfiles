filetype indent plugin on
filetype plugin on
syntax on

set hlsearch "highlight search
set showcmd "something about showing partial commands at the end of a line
set wildmode=longest,list,full
set wildmenu "command line completion
set number "line numbers
set ignorecase "ignore case when searching... 
set smartcase " ...except when using captial letters
set autoindent "keep same indent as previous line on new line
set clipboard=unnamed "use the system clipboard
set confirm "instead of failing command because of unsaved changes, prompt user
set rtp+="c/ProgramData/chocolatey/bin"
set tabstop=4 "width of a tab

map <Space>; A;<Esc>
map zl :so ~/.vsvimrc<CR>
nmap <Space>w :w<CR>
nmap <Space>q :q<CR>

" let g:rg_command = '
"   \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
"   \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
"   \ -g "!{.git,node_modules,vendor}/*" '
" 
" command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)
