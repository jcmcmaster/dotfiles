"---------"
" VimPlug "
"---------"
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf.vim' 
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " on-demand loading
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'christoomey/vim-tmux-navigator'
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'
Plug 'vim-syntastic/syntastic'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'OrangeT/vim-csharp'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'ycm-core/YouCompleteMe'
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'

" Themes...
Plug 'rafi/awesome-vim-colorschemes'

call plug#end()

"----------"
" Settings "
"----------"
filetype indent plugin on
highlight Comment cterm=italic
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

set encoding=utf-8
syntax enable
" colorscheme modest
" colorscheme solarized8
colorscheme iceberg
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
set background=dark

" airline vars
let g:airline#extensions#tabline#enabled=1 
let g:airline_powerline_fonts=1
let g:airline_theme='iceberg'
let g:airline_solarized_bg='dark'

" omnisharp vars
let g:OmniSharp_translate_cygwin_wsl = 1
let g:OmniSharp_server_path = '/mnt/c/Program Files/OmniSharp/OmniSharp.exe'
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_selector_ui = 'fzf' " Use fzf.vim

" ultisnips vars
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" ale vars
let g:ale_linters = { 'cs': ['OmniSharp'], 'py': ['pylint'] }

" nerdtree vars
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
set cursorline
set cursorcolumn

let mapleader = " "

"----------"
" Mappings "
"----------"
map <Leader>; A;<Esc>

cnoremap gdm Gvdiffsplit origin/master:%
cnoremap gdh Gvdiffsplit head:%

nnoremap <a-h> 20zl<CR>
nnoremap <a-l> 20zr<CR>
nmap <C-p> :FZF<CR>
nmap <C-n> :noh<CR>
nmap <Leader>b :ls<CR>:b<Leader>
nmap <Leader>fz :FZF<CR>
nmap <Leader>g :Rg<CR>
nmap <Leader>h :bp<CR>
nmap <Leader>l :bn<CR>
nmap <Leader>m :<C-u>marks<CR>:normal! `
nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>q :q<CR>
nmap <Leader>w :w<CR>

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

augroup omnisharp_commands
	autocmd!
	autocmd FileType cs nnoremap <buffer> <Leader>ca :OmniSharpGetCodeActions<CR>
	autocmd FileType cs nnoremap <buffer> <Leader>cf :OmniSharpCodeFormat<CR>
	autocmd FileType cs nnoremap <buffer> <Leader>doc :OmniSharpDocumentation<CR>
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

" vim diff
nnoremap <expr> <Leader>j &diff ? ']c' : '<Leader>j'
nnoremap <expr> <Leader>k &diff ? '[c' : '<Leader>j'

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

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
