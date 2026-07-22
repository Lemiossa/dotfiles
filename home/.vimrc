" Configs 
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set scrolloff=8
set undofile
set undodir=~/.vim/undo
set laststatus=2
syntax on

au BufRead,BufNewFile *.asm,*.ASM set ft=nasm

" Plugins
call plug#begin() 

Plug 'joshdick/onedark.vim', { 'as': 'onedark', 'branch': 'main' }
Plug 'jiangmiao/auto-pairs'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'lilydjwg/colorizer'

call plug#end()

" Colors and themes
set termguicolors
silent! colorscheme onedark
set background=dark

let g:lightline = {
	\ 'colorscheme': 'onedark',
	  \ }

" Autopairs
au FileType c,cpp,javascript let b:AutoPairs = AutoPairsDefine({'/*':'*/'})
au FileType vim,html let b:AutoPairs = AutoPairsDefine({'<':'>'})

" Map
set clipboard=unnamedplus
let mapleader=","

" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

" Autocomplete
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set updatetime=300
set omnifunc=ccomplete#Complete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" Indentation
set list
set listchars=tab:»·,trail:·

" LSP
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
	
endfunction

augroup lsp_install
	au!
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

augroup ThemeReload
	autocmd!
	autocmd FocusGained * if filereadable(expand("~/.cache/theme_reload")) | source ~/.vimrc | call delete(expand("~/.cache/theme_reload")) | endif
augroup END

