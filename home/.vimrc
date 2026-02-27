" ============================================================
"  _   _ ___ __  __ ____   ____
" | | | |_ _|  \/  |  _ \ / ___|
" | | | || || |\/| | |_) | |
" | |_| || || |  | |  _ <| |___
"  \___/|___|_|  |_|_| \_\\____|
"
" ============================================================

set nocompatible
filetype plugin indent on
syntax on

augroup filetype_detection
    autocmd!
    autocmd BufNewFile,BufRead *.s,*.S set filetype=gas
    autocmd BufNewFile,BufRead *.asm   set filetype=nasm
augroup END

set ttyfast
set lazyredraw
set synmaxcol=200
set updatetime=250
set re=0                      " novo motor de regex (mais rápido)
set timeoutlen=500            " tempo de espera para mapeamentos
set ttimeoutlen=10            " tempo de espera para sequências de teclas

call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'       " ícones de arquivo (requer Nerd Font!)
Plug 'luochen1990/rainbow'          " parênteses coloridos por nível
Plug 'Yggdroot/indentLine'          " guias de indentação

" — Navegação e busca
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'           " explorador de arquivos completo
Plug 'Xuyuanp/nerdtree-git-plugin'  " status git no NERDTree

" — Edição
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'             " repete comandos de plugins com '.'
Plug 'editorconfig/editorconfig-vim'
Plug 'mg979/vim-visual-multi'       " múltiplos cursores (como VS Code Ctrl+D)
Plug 'junegunn/vim-easy-align'      " alinhamento de texto por delimitador

" — Git
Plug 'mhinz/vim-signify'            " diff no sign column
Plug 'tpope/vim-fugitive'           " git integrado (:Git ...)

" — LSP e autocompletar
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" — Sintaxe aprimorada
Plug 'sheerun/vim-polyglot'

" — Qualidade de vida
Plug 'mhinz/vim-startify'           " tela de boas-vindas com recentes
Plug 'unblevable/quick-scope'        " destaca letras para f/F/t/T
Plug 'machakann/vim-highlightedyank' " pisca o texto copiado
Plug 'romainl/vim-cool'              " desativa highlight de busca ao mover

call plug#end()

set background=dark
let g:gruvbox_background = 'medium'   " soft | medium | hard
let g:gruvbox_better_performance = 1
let g:gruvbox_enable_italic = 1
let g:gruvbox_enable_bold = 1
colorscheme gruvbox

" Fundo transparente (descomente se usar terminal transparente)
" hi Normal guibg=NONE ctermbg=NONE
" hi SignColumn guibg=NONE ctermbg=NONE

let g:airline_theme = 'gruvbox'
let g:airline#extensions#tabline#enabled = 1        " mostrar abas
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#branch#enabled = 1         " mostrar branch git
let g:airline#extensions#lsp#enabled = 1
let g:airline_powerline_fonts = 1                    " requer Nerd Font!
" Fallback sem Nerd Font (comente o de cima e descomente abaixo):
" let g:airline_symbols_ascii = 1

" Símbolos manuais se não tiver Nerd Font
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

set number
set relativenumber                " números relativos = saltos mais fáceis
set signcolumn=yes
set cursorline                    " destaca linha atual
set colorcolumn=80,120            " régua de colunas
set laststatus=2
set showcmd                       " mostra comando sendo digitado
set showmatch                     " pisca o par do bracket
set noshowmode                    " airline já mostra o modo

set mouse=a
set scrolloff=8
set sidescrolloff=5
set splitbelow splitright
set hidden                        " permite trocar buffer sem salvar
set confirm                       " pergunta antes de fechar sem salvar
set autoread                      " recarrega arquivos modificados fora do vim
set noswapfile                    " sem arquivos .swp
set undofile                      " desfazer persistente entre sessões!
set undodir=~/.vim/undo//
set history=1000

set incsearch                     " busca incremental
set hlsearch                      " destaca resultados
set ignorecase                    " busca sem diferenciar maiúsculas
set smartcase                     " ...mas diferencia se tiver maiúscula

set tabstop=4
set shiftwidth=4
set noexpandtab
set autoindent
set smartindent

set list
set listchars=tab:›\ ,trail:·,extends:›,precedes:‹,nbsp:·

if has('unnamedplus')
    set clipboard=unnamedplus
endif

set wildmenu
set wildmode=longest:full,full
set wildignore=*.o,*.obj,*.pyc,*.class,node_modules/**,.git/**

" ══════════════════════════════════════════════════════════════
"  MAPEAMENTOS
" ══════════════════════════════════════════════════════════════

let mapleader = ","

" — Salvar / Sair
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>
nnoremap <C-s>     :w<CR>
inoremap <C-s>     <Esc>:w<CR>a

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

" — Mover linhas (Alt+J/K no visual e normal)
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

" — Y coerente (igual C e D: age até o fim da linha)
nnoremap Y y$

" — Centralizar após busca
nnoremap n nzzzv
nnoremap N Nzzzv

" — Centralizar ao pular meia-página
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" ── NERDTree ─────────────────────────────────────────────────
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>E :NERDTreeFind<CR>   " revela arquivo atual
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable  = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeIgnore = ['\.pyc$', '__pycache__', '\.git$', 'node_modules']
" Fecha o Vim se NERDTree for a última janela
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 &&
    \ exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" ── FZF ──────────────────────────────────────────────────────
nnoremap <C-p>     :Files<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>/ :BLines<CR>       " busca nas linhas do buffer atual

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

" ── vim-easy-align ───────────────────────────────────────────
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" Exemplo: selecione linhas e `ga=` alinha pelo sinal `=`

" ── Rainbow Parentheses ──────────────────────────────────────
let g:rainbow_active = 1

" ── Quick-scope ──────────────────────────────────────────────
" Destaca letras únicas por linha para movimentos f/F/t/T
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" ── IndentLine ───────────────────────────────────────────────
let g:indentLine_enabled = 1
let g:indentLine_char = '│'
let g:indentLine_fileTypeExclude = ['help', 'nerdtree', 'fzf', 'startify', 'json']

" ── Autopairs (C/C++) ────────────────────────────────────────
au FileType c,cpp let b:AutoPairs = AutoPairsDefine({'/*' : '*/'})

" ── Vim Startify ─────────────────────────────────────────────
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1
let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['   Sessões']       },
    \ { 'type': 'files',     'header': ['   Recentes']      },
    \ { 'type': 'dir',       'header': ['   Pasta: ' . getcwd()] },
    \ { 'type': 'bookmarks', 'header': ['   Favoritos']     },
    \ ]
let g:startify_bookmarks = [
    \ { 'v': '~/.vimrc' },
    \ { 'z': '~/.zshrc' },
    \ ]

" ── LSP ──────────────────────────────────────────────────────
let g:lsp_format_sync_timeout = 1000
let g:lsp_diagnostics_virtual_text_enabled = 0  " menos poluição visual
let g:lsp_document_highlight_enabled = 1

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

    nmap <buffer> gd         <plug>(lsp-definition)
    nmap <buffer> gD         <plug>(lsp-declaration)
    nmap <buffer> gr         <plug>(lsp-references)
    nmap <buffer> gi         <plug>(lsp-implementation)
    nmap <buffer> gt         <plug>(lsp-type-definition)
    nmap <buffer> K          <plug>(lsp-hover)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> <leader>ca <plug>(lsp-code-action)
    nmap <buffer> [g         <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g         <plug>(lsp-next-diagnostic)
    nmap <buffer> gs         <plug>(lsp-document-symbol-search)
    nmap <buffer> gS         <plug>(lsp-workspace-symbol-search)
    nnoremap <buffer> <expr><C-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><C-b> lsp#scroll(-4)
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" ── Autocompletar (asyncomplete) ─────────────────────────────
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_pum() : "\<cr>"
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1

" ══════════════════════════════════════════════════════════════
"  AUTOCMDS UTILITÁRIOS
" ══════════════════════════════════════════════════════════════

" Remove espaços em branco ao salvar
autocmd BufWritePre * %s/\s\+$//e

" Volta para a última posição do cursor ao abrir arquivo
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Cria diretório de undo se não existir
if !isdirectory(expand('~/.vim/undo'))
    call mkdir(expand('~/.vim/undo'), 'p')
endif

" Recarrega .vimrc ao salvar
autocmd BufWritePost $MYVIMRC source $MYVIMRC

" ── Dica de instalação ───────────────────────────────────────
" Para instalar todos os plugins:  :PlugInstall
"
" Fontes recomendadas (para ícones e airline bonito):
"   https://www.nerdfonts.com/  →  JetBrainsMono Nerd Font
"   ou FiraCode Nerd Font
"
" LSP servers são instalados automaticamente com vim-lsp-settings:
"   abra um arquivo .py, .c, .cpp, .js etc. e rode :LspInstallServer
"
" Dependências externas recomendadas:
"   - ripgrep  (rg)   → para busca com :Rg
"   - fd       (fd)   → busca de arquivos mais rápida com :Files
