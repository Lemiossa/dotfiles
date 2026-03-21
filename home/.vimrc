" Configs iniciais
set number
set tabstop=4
set shiftwidth=4
set scrolloff=8
set undofile
set undodir=~/.vim/undo
syntax on

" Plugins
call plug#begin() 
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'jiangmiao/auto-pairs'
call plug#end()

" Autopairs
au FileType c,cpp let b:AutoPairs = AutoPairsDefine({'/*':'*/'})

" Cores
colorscheme gruvbox
set background=dark

" Map
set clipboard=unnamedplus
let mapleader=" "

nnoremap <leader>y "+y
vnoremap <leader>y "+y

nnoremap <leader>p "+p
vnoremap <leader>p "+p

" Para pratica
nnoremap <Up>    <Nop>
nnoremap <Down>  <Nop>
nnoremap <Left>  <Nop>
nnoremap <Right> <Nop>

inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
inoremap <Left>  <Nop>
inoremap <Right> <Nop>

