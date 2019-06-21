"----------"
" Settings "
"----------"
filetype indent plugin on
syntax enable

let g:gruvbox_italic=1
"colorscheme gruvbox
set background=dark

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
nnoremap <Esc> :noh<CR><Esc>

"---------"
" VimPlug "
"---------"
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " on-demand loading
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf.vim' 
Plug 'morhetz/gruvbox'
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

call plug#end()

let g:airline#extensions#tabline#enabled=1 
