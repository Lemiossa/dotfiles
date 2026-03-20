"  _   _ ___ __  __ ____   ____
" | | | |_ _|  \/  |  _ \ / ___|
" | | | || || |\/| | |_) | |
" | |_| || || |  | |  _ <| |___
"  \___/|___|_|  |_|_| \_\\____|


set nocompatible
filetype plugin indent on
syntax on

" Detecta tipos de arquivo assembly corretamente
augroup filetype_detection
	autocmd!
	autocmd BufNewFile,BufRead *.s,*.S set filetype=gas
	autocmd BufNewFile,BufRead *.asm   set filetype=nasm
augroup END

"  PERFORMANCE

set ttyfast
set lazyredraw
set synmaxcol=200
set updatetime=100              " mais rápido que 250 — melhora signify e LSP
set timeoutlen=500
set ttimeoutlen=10
set re=0                        " novo motor de regex

" Desativa recursos pesados em arquivos grandes (>500 KB)
augroup large_files
	autocmd!
	autocmd BufReadPre * if getfsize(expand('%')) > 500000 |
		\ setlocal syntax=OFF noswapfile noundofile noloadplugins |
		\ endif
augroup END

"  PLUGINS (vim-plug)

call plug#begin('~/.vim/plugged')

" — Aparência
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'luochen1990/rainbow'
Plug 'Yggdroot/indentLine'

" — Navegação e busca
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" — Edição
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'editorconfig/editorconfig-vim'
Plug 'mg979/vim-visual-multi'
Plug 'junegunn/vim-easy-align'

" — Git
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'

" — LSP e autocompletar
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" — Sintaxe aprimorada
Plug 'sheerun/vim-polyglot'

" — Qualidade de vida
Plug 'mhinz/vim-startify'
Plug 'unblevable/quick-scope'
Plug 'machakann/vim-highlightedyank'
Plug 'romainl/vim-cool'

call plug#end()

"  APARÊNCIA E CORES

set background=dark
let g:gruvbox_contrast_dark  = 'soft'
let g:gruvbox_bold            = 0
let g:gruvbox_italic          = 0
let g:gruvbox_invert_selection = 0
set notermguicolors
colorscheme gruvbox

set completeopt=menuone,noinsert,noselect

let g:asyncomplete_auto_completeopt  = 0
let g:asyncomplete_auto_popup        = 1
let g:asyncomplete_popup_delay       = 80  " pequeno delay evita poluição

let g:airline_theme                              = 'gruvbox'
let g:airline_powerline_fonts                    = 1
let g:airline#extensions#tabline#enabled         = 1
let g:airline#extensions#tabline#formatter       = 'unique_tail'
let g:airline#extensions#tabline#show_buffers    = 0   " só abas, sem buffers
let g:airline#extensions#tabline#show_tab_count  = 1
let g:airline#extensions#branch#enabled          = 1
let g:airline#extensions#lsp#enabled             = 1
let g:airline#extensions#hunks#enabled           = 1   " diff +/-/~ do signify
let g:airline#extensions#whitespace#enabled      = 0   " menos poluição

" Seção direita: filetype + encoding + posição
let g:airline_section_x = '%{&filetype}'
let g:airline_section_y = '%{&fileencoding?&fileencoding:&encoding} [%{&fileformat}]'
let g:airline_section_z = '%3p%% ☰ %3l:%-2c'

" Garante símbolos corretos com Nerd Font
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.branch    = ''
let g:airline_symbols.readonly  = ''
let g:airline_symbols.dirty     = '!'
let g:airline_left_sep          = ''
let g:airline_left_alt_sep      = ''
let g:airline_right_sep         = ''
let g:airline_right_alt_sep     = ''

"  INTERFACE

set number
set relativenumber
set signcolumn=yes
set cursorline
set colorcolumn=80,120
set laststatus=2
set showcmd
set showmatch
set noshowmode          " airline já exibe o modo

set mouse=a
set scrolloff=8
set sidescrolloff=5
set splitbelow splitright
set hidden
set confirm
set autoread
set noswapfile
set undofile
set undodir=~/.vim/undo//
set history=1000

"  BUSCA

set incsearch
set hlsearch
set ignorecase
set smartcase

"  INDENTAÇÃO

set tabstop=4
set shiftwidth=4
set noexpandtab
set autoindent
set smartindent

"  CARACTERES VISÍVEIS

set list
set listchars=tab:›\ ,trail:·,extends:›,precedes:‹,nbsp:·

"  CLIPBOARD

if has('unnamedplus')
	set clipboard=unnamedplus
elseif has('clipboard')
	set clipboard=unnamed
endif

"  WILDMENU

set wildmenu
set wildmode=longest:full,full
set wildignore=*.o,*.obj,*.pyc,*.class,node_modules/**,.git/**,*.d,*.elf

"  MAPEAMENTOS

let mapleader = ","
let maplocalleader = "\\"

" — Salvar / Sair
nnoremap <leader>w  :w<CR>
nnoremap <leader>q  :q<CR>
nnoremap <leader>Q  :qa!<CR>
nnoremap <C-s>      :w<CR>
inoremap <C-s>      <Esc>:w<CR>a

" — Navegação de janelas (Alt + hjkl)
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l

" — Redimensionar janelas
nnoremap <M-Left>  <C-w><
nnoremap <M-Right> <C-w>>
nnoremap <M-Up>    <C-w>+
nnoremap <M-Down>  <C-w>-

" — Abas
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <TAB>      :tabnext<CR>
nnoremap <S-TAB>    :tabprevious<CR>

" — Mover linhas (Alt+J/K)
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" — Clipboard
vnoremap <C-c> "+y
vnoremap <C-x> "+d
nnoremap <C-v> "+p
vnoremap <C-v> "+p
inoremap <C-v> <C-r>+
nnoremap <C-a> ggVG

" — Limpar highlight de busca
nnoremap <leader><space> :nohlsearch<CR>

" — Manter seleção após indentar
vnoremap < <gv
vnoremap > >gv

" — Y coerente (igual C e D)
nnoremap Y y$

" — Centralizar após busca / pulo
nnoremap n     nzzzv
nnoremap N     Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" — Evita a armadilha do Q (modo ex acidental)
nnoremap Q <nop>

" — Editar e recarregar vimrc rapidamente
nnoremap <leader>ve :edit $MYVIMRC<CR>
nnoremap <leader>vr :source $MYVIMRC<CR> \| :echo "vimrc recarregado!"<CR>

" — Trocar de buffer sem fechar janela
nnoremap <leader>bd :bp\|bd #<CR>

" ── NERDTree ─────────────────────────────────────────────────
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>E :NERDTreeFind<CR>

let g:NERDTreeShowHidden          = 1
let g:NERDTreeMinimalUI           = 1
let g:NERDTreeAutoDeleteBuffer    = 1   " deleta buffer ao deletar arquivo
let g:NERDTreeDirArrowExpandable  = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeIgnore = ['\.pyc$', '__pycache__', '\.git$', 'node_modules', '\.o$', '\.d$', '\.elf$']

" Fecha o Vim se NERDTree for a última janela
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 &&
	\ exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Evita que NERDTree abra arquivos no próprio painel
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
	\ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" ── FZF ──────────────────────────────────────────────────────
nnoremap <C-p>     :Files<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>: :History:<CR>   " histórico de comandos
nnoremap <leader>gc :BCommits<CR>  " commits do buffer atual

let g:fzf_layout = { 'down': '~35%' }
let g:fzf_colors = {
	\ 'fg':      ['fg', 'Normal'],
	\ 'bg':      ['bg', 'Normal'],
	\ 'hl':      ['fg', 'Comment'],
	\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
	\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
	\ 'hl+':     ['fg', 'Statement'],
	\ 'info':    ['fg', 'PreProc'],
	\ 'border':  ['fg', 'Ignore'],
	\ 'prompt':  ['fg', 'Conditional'],
	\ 'pointer': ['fg', 'Exception'],
	\ 'marker':  ['fg', 'Keyword'],
	\ 'spinner': ['fg', 'Label'],
	\ 'header':  ['fg', 'Comment'] }

" Preview com bat se disponível
if executable('bat')
	let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-/']
	command! -bang -nargs=* Rg
		\ call fzf#vim#grep(
		\   'rg --column --line-number --no-heading --color=always --smart-case '.<q-args>, 1,
		\   fzf#vim#with_preview(), <bang>0)
endif

" ── vim-easy-align ───────────────────────────────────────────
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" ── Rainbow Parentheses ──────────────────────────────────────
let g:rainbow_active = 1

" ── Quick-scope ──────────────────────────────────────────────
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" ── IndentLine ───────────────────────────────────────────────
let g:indentLine_enabled          = 1
let g:indentLine_char             = '│'
let g:indentLine_fileTypeExclude  = ['help', 'nerdtree', 'fzf', 'startify', 'json', 'markdown']
let g:indentLine_bufTypeExclude   = ['terminal']

" ── Autopairs (C/C++) ────────────────────────────────────────
au FileType c,cpp let b:AutoPairs = AutoPairsDefine({'/*' : '*/'})

" ── vim-signify ──────────────────────────────────────────────
let g:signify_sign_add               = '▎'
let g:signify_sign_delete            = '▎'
let g:signify_sign_change            = '▎'
let g:signify_sign_delete_first_line = '▔'

" ── vim-highlightedyank ──────────────────────────────────────
let g:highlightedyank_highlight_duration = 200

" ── Vim Startify ─────────────────────────────────────────────
let g:startify_change_to_vcs_root    = 1
let g:startify_fortune_use_unicode   = 1
let g:startify_session_persistence   = 1
let g:startify_lists = [
	\ { 'type': 'sessions',  'header': ['   Sessões']          },
	\ { 'type': 'files',     'header': ['   Recentes']         },
	\ { 'type': 'dir',       'header': ['   Pasta: ' . getcwd()] },
	\ { 'type': 'bookmarks', 'header': ['   Favoritos']        },
	\ ]
let g:startify_bookmarks = [
	\ { 'v': '~/.vimrc' },
	\ { 'z': '~/.zshrc' },
	\ ]

"  LSP

let g:lsp_format_sync_timeout              = 1000
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_document_highlight_enabled       = 1
let g:lsp_signature_auto_enabled           = 1   " mostra assinatura da função
let g:lsp_diagnostics_signs_enabled        = 1
let g:lsp_diagnostics_signs_error         = {'text': '✖'}
let g:lsp_diagnostics_signs_warning       = {'text': '⚠'}
let g:lsp_diagnostics_signs_hint          = {'text': '➤'}
let g:lsp_diagnostics_signs_information   = {'text': 'ℹ'}

" clangd — configuração otimizada para projetos com Makefile/bare-metal
if executable('clangd')
	au User lsp_setup call lsp#register_server({
		\ 'name': 'clangd',
		\ 'cmd': {server_info -> [
		\   'clangd',
		\   '--background-index',
		\   '--clang-tidy',
		\   '--header-insertion=iwyu',
		\   '--completion-style=detailed',
		\   '--function-arg-placeholders',
		\   '--fallback-style=llvm',
		\   '--log=error',
		\ ]},
		\ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
		\ })
endif

function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal signcolumn=yes
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

	" Navegação
	nmap <buffer> gd          <plug>(lsp-definition)
	nmap <buffer> gD          <plug>(lsp-declaration)
	nmap <buffer> gr          <plug>(lsp-references)
	nmap <buffer> gi          <plug>(lsp-implementation)
	nmap <buffer> gt          <plug>(lsp-type-definition)
	nmap <buffer> gp          <plug>(lsp-peek-definition)   " peek sem sair

	" Info
	nmap <buffer> K           <plug>(lsp-hover)
	nmap <buffer> <leader>rn  <plug>(lsp-rename)
	nmap <buffer> <leader>ca  <plug>(lsp-code-action)
	nmap <buffer> <leader>cl  <plug>(lsp-code-lens)

	" Diagnósticos
	nmap <buffer> [g          <plug>(lsp-previous-diagnostic)
	nmap <buffer> ]g          <plug>(lsp-next-diagnostic)
	nmap <buffer> <leader>dl  <plug>(lsp-document-diagnostics)

	" Símbolos
	nmap <buffer> gs          <plug>(lsp-document-symbol-search)
	nmap <buffer> gS          <plug>(lsp-workspace-symbol-search)

	" Scroll no popup de hover
	nnoremap <buffer> <expr><C-f> lsp#scroll(+4)
	nnoremap <buffer> <expr><C-b> lsp#scroll(-4)

	" Formato ao salvar (descomente se quiser)
	" autocmd BufWritePre <buffer> LspDocumentFormatSync
endfunction

augroup lsp_install
	au!
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"  AUTOCOMPLETAR (asyncomplete)
"  NOTA: completeopt e auto_completeopt já foram setados no
"  bloco do Airline acima — não repetir aqui!

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_pum() . "\<CR>" : "\<CR>"
" Fecha o popup com Esc sem sair do insert mode
inoremap <expr> <Esc>   pumvisible() ? asyncomplete#close_pum() : "\<Esc>"

"  AUTOCMDS UTILITÁRIOS

augroup utils
	autocmd!

	" Remove espaços em branco ao salvar (exceto markdown onde importa)
	autocmd BufWritePre * if &filetype !=# 'markdown' | %s/\s\+$//e | endif

	" Volta para a última posição do cursor ao abrir arquivo
	autocmd BufReadPost *
		\ if line("'\"") > 1 && line("'\"") <= line("$") && &filetype !~# 'commit' |
		\   exe "normal! g`\"" |
		\ endif

	" Recarrega .vimrc ao salvar
	autocmd BufWritePost $MYVIMRC source $MYVIMRC

	" Highlight ao entrar e sair — evita que relativenumber trave em insert
	autocmd InsertEnter * set norelativenumber
	autocmd InsertLeave * set relativenumber

	" Redimensiona splits ao redimensionar terminal
	autocmd VimResized * wincmd =

augroup END

" Cria diretório de undo se não existir
if !isdirectory(expand('~/.vim/undo'))
	call mkdir(expand('~/.vim/undo'), 'p')
endif
