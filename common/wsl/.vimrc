" VimPlug "
"---------"
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " on-demand loading
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf.vim' 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'
Plug 'lifepillar/vim-solarized8'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'OrangeT/vim-csharp'
Plug 'christoomey/vim-tmux-navigator'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

"----------"
" Settings "
"----------"
filetype indent plugin on
highlight Comment cterm=italic
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

set encoding=utf-8
syntax enable
colorscheme solarized8
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
set background=dark

let g:airline#extensions#tabline#enabled=1 
let g:airline_powerline_fonts=1
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:OmniSharp_server_path = '/mnt/c/Program Files/OmniSharp/OmniSharp.exe'
let g:OmniSharp_translate_cygwin_wsl = 1
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_selector_ui = 'fzf' " Use fzf.vim
let g:ale_linters = { 'cs': ['OmniSharp'], 'py': ['pylint'] }
let NERDTreeShowHidden=1

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
set splitbelow
set splitright

let mapleader = " "

"----------"
" Mappings "
"----------"
map <Leader>; A;<Esc>

cnoremap gdm Gdiffsplit origin/master:%
cnoremap gdh Gdiffsplit head:%

nmap <C-p> :FZF<CR>
nmap <Leader>b :ls<CR>:b<Leader>
nmap <Leader>fz :FZF<CR>
nmap <Leader>g :Rg<CR>
nmap <Leader>h :bp<CR>
nmap <Leader>l :bn<CR>
nmap <Leader>m :<C-u>marks<CR>:normal! `
nmap <Leader>n :NERDTree<CR>
nmap <Leader>q :q<CR>
nmap <Leader>w :w<CR>

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

augroup omnisharp_commands
	autocmd!
	autocmd FileType cs nnoremap <buffer> <Leader>cf :OmniSharpCodeFormat<CR>
	autocmd FileType cs nnoremap <buffer> <Leader>doc :OmniSharpDocumentation<CR>
	autocmd FileType cs nnoremap <buffer> ga :OmniSharpGetCodeActions<CR>
	autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
	autocmd FileType cs nnoremap <buffer> gu :OmniSharpFindUsages<CR>
	autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbols<CR>
	autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
	autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>
	autocmd FileType cs nnoremap <buffer> <Leader>j :OmniSharpNavigateDown<CR>
	autocmd FileType cs nnoremap <buffer> <Leader>k :OmniSharpNavigateUp<CR>
	autocmd FileType cs nnoremap <buffer> <Leader>pd :OmniSharpPreviewDefinition<CR>
	autocmd FileType cs nnoremap <buffer> <Leader>pi :OmniSharpPreviewImplementations<CR>
	autocmd FileType cs nnoremap <buffer> <Leader>r :OmniSharpRename<CR>
        autocmd FileType cs nnoremap <buffer> <Leader>tl :OmniSharpTypeLookup<CR>
augroup END

au FileType python setlocal formatprg=autopep8\ -

"Vim Split Goodies
" nnoremap <C-J> <C-W><C-J> 
" nnoremap <C-K> <C-W><C-K> 
" nnoremap <C-L> <C-W><C-L> 
" nnoremap <C-H> <C-W><C-H> 

function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

