" Lightline - Gruvbox Purple
let s:bg0   = '#1D2021'
let s:bg1   = '#282828'
let s:bg2   = '#3C3836'
let s:bg3   = '#504945'
let s:fg0   = '#FBF1C7'
let s:fg1   = '#EBDBB2'
let s:fg2   = '#D5C4A1'
let s:fg3   = '#BDAE93'
let s:fg4   = '#A89984'
let s:gray  = '#928374'
let s:purple = '#D3869B'
let s:purple_dark = '#B16286'
let s:aqua  = '#8EC07C'
let s:blue  = '#83A598'
let s:yellow = '#FABD2F'
let s:red   = '#FB4934'
let s:green = '#B8BB26'
let s:orange = '#FE8019'

let s:c_bg0   = 235
let s:c_bg1   = 235
let s:c_bg2   = 237
let s:c_bg3   = 239
let s:c_fg0   = 229
let s:c_fg1   = 223
let s:c_fg2   = 250
let s:c_fg3   = 248
let s:c_fg4   = 246
let s:c_gray  = 245
let s:c_purple = 175
let s:c_purple_dark = 132
let s:c_aqua  = 108
let s:c_blue  = 109
let s:c_yellow = 214
let s:c_red   = 167
let s:c_green = 142
let s:c_orange = 208

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [
    \ [ s:bg0, s:purple, s:c_bg0, s:c_purple ],
    \ [ s:fg1, s:bg2, s:c_fg1, s:c_bg2 ]
    \ ]
let s:p.normal.middle = [ [ s:fg2, s:bg1, s:c_fg2, s:c_bg1 ] ]
let s:p.normal.right = [
    \ [ s:fg1, s:bg3, s:c_fg1, s:c_bg3 ],
    \ [ s:fg4, s:bg2, s:c_fg4, s:c_bg2 ]
    \ ]

let s:p.inactive.left = [
    \ [ s:fg4, s:bg1, s:c_fg4, s:c_bg1 ],
    \ [ s:gray, s:bg1, s:c_gray, s:c_bg1 ]
    \ ]
let s:p.inactive.middle = [ [ s:gray, s:bg1, s:c_gray, s:c_bg1 ] ]
let s:p.inactive.right = [
    \ [ s:gray, s:bg1, s:c_gray, s:c_bg1 ],
    \ [ s:gray, s:bg2, s:c_gray, s:c_bg2 ]
    \ ]

let s:p.insert.left = [
    \ [ s:bg0, s:aqua, s:c_bg0, s:c_aqua ],
    \ [ s:fg1, s:bg2, s:c_fg1, s:c_bg2 ]
    \ ]
let s:p.replace.left = [
    \ [ s:bg0, s:red, s:c_bg0, s:c_red ],
    \ [ s:fg1, s:bg2, s:c_fg1, s:c_bg2 ]
    \ ]
let s:p.visual.left = [
    \ [ s:bg0, s:yellow, s:c_bg0, s:c_yellow ],
    \ [ s:fg1, s:bg2, s:c_fg1, s:c_bg2 ]
    \ ]

let s:p.insert.middle = s:p.normal.middle
let s:p.replace.middle = s:p.normal.middle
let s:p.visual.middle = s:p.normal.middle
let s:p.insert.right = s:p.normal.right
let s:p.replace.right = s:p.normal.right
let s:p.visual.right = s:p.normal.right

let s:p.tabline.left = [ [ s:fg1, s:bg2, s:c_fg1, s:c_bg2 ] ]
let s:p.tabline.tabsel = [ [ s:bg0, s:purple, s:c_bg0, s:c_purple ] ]
let s:p.tabline.middle = [ [ s:bg2, s:bg1, s:c_bg2, s:c_bg1 ] ]
let s:p.tabline.right = copy(s:p.normal.right)

let s:p.normal.error = [ [ s:bg0, s:red, s:c_bg0, s:c_red ] ]
let s:p.normal.warning = [ [ s:bg0, s:yellow, s:c_bg0, s:c_yellow ] ]

let g:lightline#colorscheme#gruvbox_purple#palette = s:p
