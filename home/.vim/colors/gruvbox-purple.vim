" Gruvbox Purple - Gruvbox com destaque roxo
" Baseado em morhetz/gruvbox (https://github.com/morhetz/gruvbox)

let g:gruvbox_contrast_dark = 'hard'
runtime colors/gruvbox.vim
let g:colors_name = 'gruvbox-purple'

"""""""""""""""""""""""""""""
" Destaques em roxo          "
"""""""""""""""""""""""""""""

" Cursor
hi Cursor       guifg=#1D2021 guibg=#D3869B ctermfg=235 ctermbg=175
hi CursorIM     guifg=#1D2021 guibg=#D3869B ctermfg=235 ctermbg=175
hi TermCursor   guifg=#1D2021 guibg=#D3869B ctermfg=235 ctermbg=175
hi TermCursorNC guifg=#1D2021 guibg=#B16286 ctermfg=235 ctermbg=132

" Código
hi Identifier   guifg=#D3869B ctermfg=175
hi Function     guifg=#D3869B gui=bold ctermfg=175 cterm=bold

" Interface
hi CursorLineNr guifg=#D3869B guibg=#282828 gui=bold ctermfg=175 ctermbg=235 cterm=bold
hi Directory    guifg=#D3869B ctermfg=175
hi Title        guifg=#D3869B gui=bold ctermfg=175 cterm=bold
hi Search       guifg=#1D2021 guibg=#D3869B gui=bold ctermfg=235 ctermbg=175 cterm=bold
hi IncSearch    guifg=#1D2021 guibg=#B16286 gui=bold ctermfg=235 ctermbg=132 cterm=bold
hi MatchParen   guifg=#1D2021 guibg=#D3869B gui=bold ctermfg=235 ctermbg=175 cterm=bold
hi PmenuSel     guifg=#1D2021 guibg=#D3869B gui=bold ctermfg=235 ctermbg=175 cterm=bold
hi WildMenu     guifg=#1D2021 guibg=#D3869B gui=bold ctermfg=235 ctermbg=175 cterm=bold
hi StatusLine   guifg=#1D2021 guibg=#D3869B gui=NONE ctermfg=235 ctermbg=175 cterm=NONE
hi StatusLineNC guifg=#A89984 guibg=#3C3836 gui=NONE ctermfg=246 ctermbg=237 cterm=NONE
hi TabLineSel   guifg=#1D2021 guibg=#D3869B gui=bold ctermfg=235 ctermbg=175 cterm=bold
hi VertSplit    guifg=#3C3836 guibg=#1D2021 ctermfg=237 ctermbg=235
hi Visual       guibg=#4B2C3A ctermbg=236
hi VisualNOS    guibg=#4B2C3A ctermbg=236
hi LineNr       guifg=#665C54 guibg=#1D2021 ctermfg=241 ctermbg=235
hi CursorLine   guibg=#282828 ctermbg=235
hi ColorColumn  guibg=#3C3836 ctermbg=237
hi Folded       guifg=#A89984 guibg=#282828 ctermfg=246 ctermbg=235
hi FoldColumn   guifg=#A89984 guibg=#1D2021 ctermfg=246 ctermbg=235
hi SignColumn   guibg=#1D2021 ctermbg=235
hi Pmenu        guifg=#EBDBB2 guibg=#3C3836 ctermfg=223 ctermbg=237
hi PmenuSbar    guibg=#3C3836 ctermbg=237
hi PmenuThumb   guibg=#D3869B ctermbg=175

" Diffs e plugins
hi DiffChange        guifg=#D3869B guibg=#3C3836 ctermfg=175 ctermbg=237
hi DiffText          guifg=#1D2021 guibg=#D3869B ctermfg=235 ctermbg=175
hi GitGutterChange   guifg=#D3869B ctermfg=175
hi GitGutterChangeDelete guifg=#D3869B ctermfg=175
hi SpellCap          guifg=#D3869B ctermfg=175

" Mensagens
hi WarningMsg guifg=#FABD2F ctermfg=214
hi ErrorMsg   guifg=#1D2021 guibg=#FB4934 gui=bold ctermfg=235 ctermbg=167 cterm=bold
hi Todo       guifg=#1D2021 guibg=#FABD2F gui=bold ctermfg=235 ctermbg=214 cterm=bold
