"---------"
" VimPlug "
"---------"
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " on-demand loading
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf.vim' 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-dadbod'

call plug#end()

"----------"
" Settings "
"----------"
filetype indent plugin on
syntax enable
set background=dark
highlight Comment cterm=italic

let g:airline#extensions#tabline#enabled=1 
let g:airline_theme='dracula'
let g:gruvbox_italic=1

let g:OmniSharp_server_path = '/mnt/c/OmniSharp/omnisharp-win-x64/OmniSharp.exe'
let g:OmniSharp_translate_cygwin_wsl = 1
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_selector_ui = 'fzf' " Use fzf.vim
let g:syntastic_cs_checkers = ['code_checker']

let g:ale_linters = { 'cs': ['OmniSharp'], 'py': ['pylint'] }

set nocompatible
set hlsearch "highlight search
set showcmd "something about showing partial commands at the end of a line
set wildmenu "command line completion
set relativenumber "relative line numbers
set ignorecase "ignore case when searching
set autoindent "keep same indent as previous line on new line
set confirm "instead of failing command because of unsaved changes, prompt user
set path+=** " search down into subfolders, provides tab-completion for all file-related tasks
set clipboard=unnamed "use system clipboard
set scrolloff=15

au FileType python setlocal formatprg=autopep8\ -

"----------"
" Mappings "
"----------"
map <Space>; A;<Esc>
map zl :so ~/.vsvimrc<CR>
nmap <Space>w :w<CR>
nmap <Space>q :q<CR>
nnoremap <Space>m :<C-u>marks<CR>:normal! `
nnoremap <Space>b :ls<CR>:b<Space>
nnoremap <Space>n :NERDTree<CR>
nnoremap <Space>f :FZF<CR>
nnoremap <Space>g :Rg<CR>
"nnoremap <Esc> :noh<CR><Esc>

"Vim Split Goodies
nnoremap <C-J> <C-W><C-J> 
nnoremap <C-K> <C-W><C-K> 
nnoremap <C-L> <C-W><C-L> 
nnoremap <C-H> <C-W><C-H> 
