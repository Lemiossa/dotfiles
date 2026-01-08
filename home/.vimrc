set nocompatible
filetype plugin indent on
syntax on

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
Plug 'shirk/vim-gas'
Plug 'joshdick/onedark.vim'
call plug#end()

set background=dark
set termguicolors
let g:onedark_contrast = "medium"
colorscheme onedark

let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

set number relativenumber
set tabstop=4
set shiftwidth=4
set smartindent
set hidden
set updatetime=300
set signcolumn=yes
set mouse=a
set clipboard=unnamedplus
set ignorecase
set smartcase
set incsearch
set hlsearch
set splitbelow
set splitright
set scrolloff=8
set lazyredraw
set ttyfast

set synmaxcol=200
set re=1
set nocursorline
set noshowmatch

set wildmenu
set wildmode=longest:full,full
set undofile
set undodir=~/.vim/undo
set nobackup
set nowritebackup
set noswapfile

let mapleader = " "

" Clipboard xclip
vnoremap <C-c> y:call system('xclip -selection clipboard', @")<CR>
vnoremap <C-x> d:call system('xclip -selection clipboard', @")<CR>
nnoremap <C-v> :call setreg('"', system('xclip -selection clipboard -o'))<CR>p
inoremap <C-v> <C-r>=system('xclip -selection clipboard -o')<CR>
nnoremap <leader>p :set paste<CR>:call setreg('"', system('xclip -selection clipboard -o'))<CR>p:set nopaste<CR>
nnoremap <C-a> ggVG

" FZF
nnoremap <C-p> :Files<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>b :Buffers<CR>

" General
nnoremap <leader>l :tabnext<CR>
nnoremap <leader>h :tabprevious<CR>
nnoremap <leader>n :tabnew<CR>
nnoremap <leader>c :tabclose<CR>

nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :Lexplore<CR>
nmap <C-_> gcc
vmap <C-_> gc

let g:indentLine_setColors = 0
let g:indentLine_enabled = 0
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

" Auto-commands
autocmd BufWritePre * %s/\s\+$//e
autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" LSP
if executable('clangd')
	au User lsp_setup call lsp#register_server({
		\ 'name': 'clangd',
		\ 'cmd': ['clangd'],
		\ 'allowlist': ['c', 'cpp'],
		\ })
endif

if executable('bash-language-server')
	au User lsp_setup call lsp#register_server({
		\ 'name': 'bash-language-server',
		\ 'cmd': ['bash-language-server', 'start'],
		\ 'allowlist': ['sh', 'make'],
		\ })
endif


function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

syntax on
filetype plugin on

" LSP já registrado no vimrc
setlocal omnifunc=lsp#complete
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" :
      \ (col('.') > 1 && getline('.')[col('.')-2] =~ '\k') ? "\<C-x>\<C-o>" :
      \ "\<TAB>"

inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

autocmd BufNewFile,BufRead *.s,*.S set filetype=gas
