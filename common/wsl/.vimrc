"---------"
" VimPlug "
"---------"
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dense-analysis/ale'
Plug 'gosukiwi/vim-atom-dark'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf.vim' 
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'OmniSharp/omnisharp-vim'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'will133/vim-dirdiff'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'

call plug#end()

"----------"
" Settings "
"----------"
filetype indent plugin on
highlight Comment cterm=italic
autocmd ColorScheme * highlight! link SignColumn LineNr
syntax enable

let g:codedark_italics=1
colorscheme dark_plus

set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set encoding=utf-8
set background=dark
set hlsearch "highlight search
set showcmd "something about showing partial commands at the end of a line
set wildmenu "command line completion
set number relativenumber "relative line numbers
set ignorecase "ignore case when searching
set autoindent "keep same indent as previous line on new line
set confirm "instead of failing command because of unsaved changes, prompt user
set path+=** " search down into subfolders, provides tab-completion for all file-related tasks
set clipboard=unnamedplus "use system clipboard
set splitbelow "default position of new hz split is below current window
set splitright "default position of new vt split is right of current window
set cursorline "highlight the entire current line
set cursorcolumn "highlight the entire current column
set mouse=a

let mapleader = " "

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" airline vars
let g:airline#extensions#tabline#enabled=1 
let g:airline_powerline_fonts=1
let g:airline_theme='codedark'
let g:airline_solarized_bg='dark'

" nerdtree vars
let g:NERDTreeWinSize=50

" omnisharp vars
" let g:OmniSharp_translate_cygwin_wsl = 1
" let g:OmniSharp_server_path = '/mnt/c/Users/jmcmaster/tools/OmniSharp/OmniSharp.exe'
" let g:OmniSharp_server_stdio = 1
" let g:OmniSharp_selector_ui = 'fzf' " Use fzf.vim

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
nmap <Leader>t :NERDTreeToggle<CR>
nmap <Leader>q :q<CR>
nmap <Leader>w :w<CR>

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

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

lua << EOF
require'lspconfig'.omnisharp.setup {
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  end,
  cmd = { "/home/jmcmaster/.cache/omnisharp-vim/omnisharp-roslyn/run", "--languageserver" , "--hostPID", tostring(pid) },
}
EOF

lua << EOF
-- autocomplete config
local cmp = require 'cmp'
cmp.setup {
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  },
  sources = {
    { name = 'nvim_lsp' },
  }
}
EOF
