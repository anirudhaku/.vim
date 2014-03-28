set number	                                " turn on the line number display
set background=dark                         " Set highlighting for dark background
set nocompatible                            " We're running Vim, not Vi!
set backspace=indent,eol,start              " 
set tabstop=4 shiftwidth=4 softtabstop=4    " my indentation preferences
set expandtab
set laststatus=2

filetype off    " apparently, needed before calling pathogen#infect()

" TAB related key bindings... [{
" mapping Alt + [1-0] to tab# [1-10]...
" nnoremap <M-1>   1gt
" nnoremap <C-[>2   2gt
" nnoremap <C-[>3   3gt
" nnoremap <C-[>4   4gt
" nnoremap <C-[>5   5gt
" nnoremap <C-[>6   6gt
" nnoremap <C-[>7   7gt
" nnoremap <C-[>8   8gt
" nnoremap <C-[>9   9gt
" nnoremap <C-[>0   10gt
" mapping Ctrl-[ to tabprev and Ctrl-] to tabnext...
" nnoremap <C-[>[   :tabprevious<CR>
" nnoremap <C-[>]   :tabnext<CR>
" }]

call pathogen#infect()
call pathogen#helptags()

filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
syntax on             " Enable syntax highlighting

set omnifunc=syntaxcomplete#Complete

if !has('gui_running')
    set t_Co=256
endif

"key mapping for gundo...
noremap <F5> :GundoToggle<CR>

" VIM_LATEX SETTINGS [{
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" Set default output format for vim-latex to pdf...
let g:Tex_DefaultTargetFormat = 'pdf'
" }]

" INDENTLINE SETTINGS [{
" indentLine color...
let g:indentLine_color_term=245
" }]

" LIGHTLINE settings... [{
let g:lightline = {
    \       'enable' : {
    \           'statusline': 1,
    \           'tabline': 0
    \       },
    \
    \       'active': {
    \           'left': [   
    \                       [ 'mode', 'paste' ],
    \                       [ 'fugitive', 'readonly', 'filename', 'modified' ]
    \                   ]
    \       },
    \   
    \       'component': {
    \           'readonly': '%{&readonly?"x":""}',
    \           'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
    \       },
    \   
    \       'separator': { 'left': "\u2592\u2591", 'right': "\u2591\u2592" },
    \   
    \       'subseparator': { 'left': "\u2502", 'right': "\u2502" }
    \   }
" }]

" YCM settings... [{
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'

" Mapping F12 to GoTo...
noremap <F12>   :YcmCompleter GoTo<CR>
" }]

" VIM-SESSION settings... [{
" default session directory...
let g:session_directory = './'

" name of the default session file...
let g:session_default_name = '.session'

" autoload if session file is present...
let g:session_autoload = 'yes'

" autosave if session file is present...
" As of now, this option saves the session even if there is no session open...
" let g:session_autosave = 'yes'
" }]

" TABLINE [{
" Rename tabs to show tab# and # of viewports
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= (i== t ? '%#TabNumSel#' : '%#TabNum#')
            let s .= i
            if tabpagewinnr(i,'$') > 1
                let s .= '.'
                let s .= (i== t ? '%#TabWinNumSel#' : '%#TabWinNum#')
                let s .= (tabpagewinnr(i,'$') > 1 ? wn : '')
            end

            let s .= ' %*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= file
            let s .= (i == t ? '%m' : '')
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
endif

set tabpagemax=15
hi TabLineSel term=bold cterm=bold ctermfg=16 ctermbg=229
hi TabWinNumSel term=bold cterm=bold ctermfg=90 ctermbg=229
hi TabNumSel term=bold cterm=bold ctermfg=16 ctermbg=229

hi TabLine term=underline ctermfg=16 ctermbg=145
hi TabWinNum term=bold cterm=bold ctermfg=90 ctermbg=145
hi TabNum term=bold cterm=bold ctermfg=16 ctermbg=145
hi TabLineFill term=bold cterm=bold ctermfg=16 ctermbg=000
" }]

" VIM-CSV settings... [{
aug CSV_Editing
    au!
    au BufRead,BufWritePost *.csv :%ArrangeColumn
    au BufWritePre *.csv :%UnArrangeColumn
aug end
" }]

