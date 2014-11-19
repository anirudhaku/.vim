set number	                                " turn on the line number display
set background=dark                         " Set highlighting for dark background
set nocompatible                            " We're running Vim, not Vi!
set backspace=indent,eol,start              " something something something
set tabstop=4 shiftwidth=4 softtabstop=4    " my indentation preferences
set expandtab                               " expand tabs to spaces
set laststatus=2                            " always show status line
set hlsearch                                " highlight search results
set hidden                                  " allow hidden buffers

filetype off    " apparently, needed before calling pathogen#infect()

" set term when invoked from screen
if &term == "screen"
    :set term=xterm
endif

call pathogen#infect()
call pathogen#helptags()

filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
syntax on             " Enable syntax highlighting

if !has('gui_running')
    set t_Co=256
endif

" Screen's eccentric Ctrl-Arrow sequences
map <ESC>O5D <C-Left>
map <ESC>O5C <C-Right>
map! <ESC>O5D <C-Left>
map! <ESC>O5C <C-Right>

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

" use luatex to compile tex to pdf...
let g:Tex_CompileRule_pdf = 'lualatex -interaction=nonstopmode -file-line-error-style $*'

" disable math conversion using conceal (slows down vim)...
let g:tex_conceal = ""
" }]

" INDENTLINE SETTINGS [{
" indentLine color...
let g:indentLine_color_term=245
" }]

" LIGHTLINE settings... [{
let g:lightline = {
    \       'colorscheme' : 'wombat',
    \
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
    \       'inactive': {
    \           'left': [   
    \                       [ ],
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

" disable YCM for tex files...
let g:ycm_filetype_blacklist = {
    \       'tex' : 1,
    \       'conque_term' : 1
    \   }

" Mapping F12 to GoTo...
noremap <F12>   :YcmCompleter GoTo<CR>

" disable auto completer (complete on <C-space>)...
let g:ycm_auto_trigger = 0

" hide the annoying preview window after completion...
let g:ycm_autoclose_preview_window_after_completion = 1

" }]

" VIM-SESSION settings... [{
" default session directory...
let g:session_directory = './'

" name of the default session file...
let g:session_default_name = '.session'

" autoload if session file is present...
let g:session_autoload = 'yes'

" autosave if session file is present...
let g:session_autosave = 'no'
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
    set tabline=%!MyTabLine()
endif

set showtabline=1   " disabling tabline (switching to using buffers instead)

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

" VIM-JSON settings... [{
" disable concealing (its an irritating feature)...
let g:vim_json_syntax_conceal = 0
" }]

function ShowSpaces(...)
  let @/='\v(\s+$)|( +\ze\t)'
  let oldhlsearch=&hlsearch
  if !a:0
    let &hlsearch=!&hlsearch
  else
    let &hlsearch=a:1
  end
  return oldhlsearch
endfunction

function TrimSpaces() range
  let oldhlsearch=ShowSpaces(1)
  execute a:firstline.",".a:lastline."substitute ///gec"
  let &hlsearch=oldhlsearch
endfunction

command -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()

function RefreshCscope(...)
    let l:find_args = ". -iname '*." . join(a:000, "' -o -iname '*.") . "'"
    echom l:find_args
    !rm cscope.*
    execute "!find" l:find_args '> cscope.files'
    !cscope -b -q
    cs kill -1
    cs add cscope.out
endfunction

command -bar -nargs=* RefCs call RefreshCscope(<f-args>)

" MINIBUFEXPL settings... [{
" disable by default
let g:miniBufExplorerAutoStart = 0
" }]

" MiniBufExpl Settings [{
" Map for open, close, focus and toggle...
nnoremap <Leader>o  :MBEOpen<CR>
nnoremap <Leader>c  :MBEClose<CR>
nnoremap <Leader>f  :MBEFocus<CR>
nnoremap <Leader>t  :MBEToggle<CR>

" for buffer navigation (goto, next, previous, forward and backward buffer)
function! GotoBuffer()
    let l:c = v:count
    if l:c
        execute "buffer " . l:c
    else
        MBEbn
    endif
endfunction

" <num>bg to jump to <num>th buffer
" bg to ro to next buffer
" bG to go to previous buffer
nnoremap bg     :<C-U>call GotoBuffer()<CR>
nnoremap bG     :MBEbp<CR>
nnoremap bf     :MBEbf<CR>
nnoremap bF     :MBEbb<CR>

" for buffer cleanup
function! DeleteBuffer()
    let l:c = v:count
    if l:c
        execute "MBEbd " . l:c
    else
        MBEbd
    endif
endfunction

function! WipeoutBuffer()
    let l:c = v:count
    if l:c
        execute "MBEbw " . l:c
    else
        MBEbw
    endif
endfunction

function! UnloadBuffer()
    let l:c = v:count
    if l:c
        execute "MBEbu " . l:c
    else
        MBEbu
    endif
endfunction

noremap bd      :<C-U>call DeleteBuffer()<CR>
noremap bw      :<C-U>call WipeoutBuffer()<CR>
noremap bu      :<C-U>call UnloadBuffer()<CR>

" Open veritical window...
let g:miniBufExplVSplit = 30
let g:miniBufExplMaxSize = 50
let g:miniBufExplMinSize = 30

" better highlights in MBE explorer window
hi MBENormal                                                            ctermfg=14  guifg=#80a0ff
hi MBECHanged                                                           ctermfg=224 guifg=Orange
hi MBEVisibleNormal         term=underline      cterm=underline         ctermfg=81  guifg=#ff80ff
hi MBEVisibleChanged        term=underline      cterm=underline         ctermfg=224 guifg=Orange
hi MBEVisibleActiveNormal   term=bold,underline cterm=bold,underline    ctermfg=81  guifg=#ff80ff
hi MBEVisibleActiveChanged  term=bold,underline cterm=bold,underline    ctermfg=224 guifg=Orange
" }]

