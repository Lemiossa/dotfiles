" ===============================
" PLUGINS
" ===============================
call plug#begin('~/.vim/plugged')

" Temas
Plug 'morhetz/gruvbox'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

" Árvore de arquivos
Plug 'preservim/nerdtree'

" Ícones
Plug 'ryanoasis/vim-devicons'

" Colorizer
Plug 'chrisbra/Colorizer'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax highlighting melhorado
Plug 'sheerun/vim-polyglot'

" ===== AUTOCOMPLETE TOP =====
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" ===============================
" BÁSICO
" ===============================
set nocompatible
syntax on
filetype plugin indent on
set hidden
set updatetime=300
set signcolumn=yes

" ===============================
" TEMA
" ===============================
set background=dark
set termguicolors

" Gruvbox
" let g:gruvbox_contrast_dark = 'medium'
" let g:gruvbox_italic = 1
" let g:gruvbox_bold = 1
" let g:gruvbox_improved_strings = 1
" let g:gruvbox_improved_warnings = 1

" Catppuccin 
let g:catppuccin_flavour = "mocha"
let g:catppuccin_italic_comments = 1
let g:catppuccin_italic_keywords = 1
let g:catppuccin_bold = 1
let g:catppuccin_transparent_background = 0

colorscheme catppuccin_mocha

let g:airline_theme='catppuccin_mocha'
let g:airline_powerline_fonts = 1

" ===============================
" COLORIZER
" ===============================
let g:colorizer_auto_filetype='css,html,vim'

" ===============================
" NERDTREE
" ===============================
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" ===============================
" ASSEMBLY
" ===============================
augroup asm_syntax
  autocmd!
  autocmd BufRead,BufNewFile *.s,*.S set filetype=gas
  autocmd BufRead,BufNewFile *.asm set filetype=nasm
augroup END

" ===============================
" EDITOR
" ===============================
set number
set tabstop=4
set shiftwidth=4
set expandtab
set wildmenu
set wildmode=longest:full,full
set cursorline
set undofile
set clipboard=unnamedplus

" ===============================
" COC AUTOCOMPLETE
" ===============================
set completeopt=menuone,noselect
set shortmess+=c
set belloff+=ctrlg

" Tab / Shift-Tab
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ coc#expandableOrJumpable() ? "\<Plug>(coc-snippets-expand-jump)" :
      \ "\<Tab>"

inoremap <silent><expr> <S-Tab>
      \ pumvisible() ? "\<C-p>" : "\<C-h>"

" Enter confirma
inoremap <silent><expr> <CR>
      \ pumvisible() ? coc#_select_confirm() : "\<CR>"

" Hover
nnoremap <silent> K :call CocActionAsync('doHover')<CR>

" Go to
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gy <Plug>(coc-type-definition)

" Rename símbolo
nnoremap <leader>rn <Plug>(coc-rename)

" ===============================
" CLIPBOARD (XCLIP)
" ===============================
vnoremap <C-c> y:call system('xclip -selection clipboard', @")<CR>
vnoremap <C-x> y:call system('xclip -selection clipboard', @")<CR>gvd
nnoremap <C-v> :r !xclip -selection clipboard -o<CR>
inoremap <C-v> <Esc>:r !xclip -selection clipboard -o<CR>A

" ===============================
" ATALHOS
" ===============================
nnoremap <C-a> ggVG
inoremap <C-a> <Esc>ggVG

" Mostrar autocomplete com 1 letra
let g:coc_config_home = '~/.vim'
autocmd VimEnter * :call CocActionAsync('updateConfig', {
      \ 'suggest.minTriggerInputLength': 1
      \ })

inoremap <silent><expr> <Tab>
      \ pumvisible() ? coc#pum#next(1) :
      \ coc#expandableOrJumpable() ? "\<Plug>(coc-snippets-expand-jump)" :
      \ "\<Tab>"
