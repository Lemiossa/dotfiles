set nocompatible
filetype plugin indent on
syntax on

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
call plug#end()

set background=dark
set termguicolors
let g:gruvbox_contrast_dark = 'medium'
colorscheme gruvbox

let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

set number relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
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

let mapleader = " "

" Clipboard xclip
vnoremap <C-c> y:call system('xclip -selection clipboard', @")<CR>
vnoremap <C-x> d:call system('xclip -selection clipboard', @")<CR>
nnoremap <C-v> :call setreg('"', system('xclip -selection clipboard -o'))<CR>p
inoremap <C-v> <C-r>=system('xclip -selection clipboard -o')<CR>
nnoremap <leader>p :set paste<CR>:call setreg('"', system('xclip -selection clipboard -o'))<CR>p:set nopaste<CR>
nnoremap <C-a> ggVG

" CoC Tab Autocomplete
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" CoC Navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

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
nnoremap <Esc> :noh<CR>
nmap <C-_> gcc
vmap <C-_> gc

" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

" Auto-commands
autocmd BufWritePre * %s/\s\+$//e
autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" CoC Extensions
let g:coc_global_extensions = ['coc-json', 'coc-snippets', 'coc-pairs', 'coc-clangd']
