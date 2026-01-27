augroup filetype_detection
    autocmd!
    autocmd BufNewFile,BufRead *.s,*.S set filetype=gas
augroup END

augroup filetype_detection
    autocmd!
    autocmd BufNewFile,BufRead *.asm set filetype=nasm
augroup END

set nocompatible
filetype plugin indent on
syntax on

" Performance: Reduz o lag de renderização
set ttyfast
set lazyredraw
set synmaxcol=200
set laststatus=2
set updatetime=250
set re=0

call plug#begin('~/.vim/plugged')

" Temas e UI
Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'

" Navegação e Busca
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Edição
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'editorconfig/editorconfig-vim'
Plug 'mhinz/vim-signify'
Plug 'sheerun/vim-polyglot'

" LSP e Completar
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

set background=dark
colorscheme solarized

" Configuração Lightline
let g:lightline = { 'colorscheme': 'solarized' }

set number
set signcolumn=yes
set mouse=a
set scrolloff=8
set splitbelow splitright

" Invisíveis
set list
set listchars=tab:>\ ,trail:·

let mapleader = ","

" Salvar e Sair rápido
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Melhor navegação de janelas
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l

" FZF
nnoremap <C-p> :Files<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>b :Buffers<CR>

" Explorador de arquivos nativo
nnoremap <leader>e :Lexplore<CR>
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 20

" Clipboard
if has('unnamedplus')
    set clipboard=unnamedplus
endif

vnoremap <C-c> "+y
vnoremap <C-x> "+d
nnoremap <C-v> "+p
vnoremap <C-v> "+p
inoremap <C-v> <C-r>+
nnoremap <C-a> ggVG

" Atalhos de abas mais intuitivos
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <TAB> :tabnext<CR>
nnoremap <S-TAB> :tabprevious<CR>

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Tab para completar
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_pum() : "\<cr>"

" Remove espaços em branco ao salvar
autocmd BufWritePre * %s/\s\+$//e

" Volta para a última posição do cursor ao abrir arquivo
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Desativa indentLine em arquivos grandes para não travar o scroll
let g:indentLine_enabled = 1
let g:indentLine_fileTypeExclude = ['help', 'nerdtree', 'fzf']

set tabstop=4
set shiftwidth=4
set noexpandtab

