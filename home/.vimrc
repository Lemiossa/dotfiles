" Configs iniciais
set number 
set relativenumber
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
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'

call plug#end()

" Autopairs
au FileType c,cpp let b:AutoPairs = AutoPairsDefine({'/*':'*/'})
au FileType vim,html let b:AutoPairs = AutoPairsDefine({'<':'>'})

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

" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

" Autocomplete
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set updatetime=300
set omnifunc=ccomplete#Complete
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" Para praticar o uso de hjkl
nnoremap <Up>    <Nop>
nnoremap <Down>  <Nop>
nnoremap <Left>  <Nop>
nnoremap <Right> <Nop>

vnoremap <Up>    <Nop>
vnoremap <Down>  <Nop>
vnoremap <Left>  <Nop>
vnoremap <Right> <Nop>

inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
inoremap <Left>  <Nop>
inoremap <Right> <Nop>
