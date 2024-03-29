set number	                                " turn on the line number display
set background=dark                         " Set highlighting for dark background
set nocompatible                            " We're running Vim, not Vi!
set backspace=indent,eol,start              " something something something
set tabstop=4 shiftwidth=4 softtabstop=4    " my indentation preferences
set expandtab                               " expand tabs to spaces
set laststatus=2                            " always show status line
set hlsearch                                " highlight search results
set hidden                                  " allow hidden buffers
"set clipboard=exclude:.*                    " do not try to connect to X server for accessing clipboard
set encoding=utf-8                          " fun fact: vim is basically a latin1 editor!
set colorcolumn=97                          " highlight 97th column for coding convention
highlight ColorColumn ctermbg=8 guibg=DimGray

filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
syntax on             " Enable syntax highlighting

" set term when invoked from screen
if &term == "screen"
    :set term=xterm
endif

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

" Don't conceal at cursor, helps with JSON quotes.
let g:indentLine_concealcursor = ""

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
    \                   ],
    \           'right': [
    \                       [ 'lineinfo' ],
    \                       [ 'percent' ],
    \                       [ 'fileformat', 'fileencoding', 'filetype', 'zoomstatus' ]
    \                    ]
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
    \           'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}',
    \           'zoomstatus': '%{zoom#statusline()}'
    \       },
    \   
    \       'separator': { 'left': "\u2592\u2591", 'right': "\u2591\u2592" },
    \   
    \       'subseparator': { 'left': "\u2502", 'right': "\u2502" }
    \   }
" }]

" YCM settings... [{
" disable YCM for tex files...
let g:ycm_filetype_blacklist = {
    \       'tex' : 1,
    \       'conque_term' : 1
    \   }

" Mapping F12 to GoTo...
noremap <leader>d   :YcmCompleter GoTo<CR>

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

" Spaces@EOL... [{
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
    let l:find_args = ". -path \"./build*\" -o -path ./.tup -prune -o -iname '*." . join(a:000, "' -print -o -iname '*.") . "' -print"
    echom l:find_args
    !rm cscope.*
    execute "!find" l:find_args '> cscope.files'
    !cscope -b -q
    cs kill -1
    cs add cscope.out
endfunction

command -bar -nargs=* RefCs call RefreshCscope(<f-args>)
" }]

" MINIBUFEXPL settings... [{
" disable by default
let g:miniBufExplorerAutoStart = 0
" }]

" MiniBufExpl Settings [{
" Map for open, close, focus and toggle...
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
noremap bq      :<C-U>call WipeoutBuffer()<CR> <bar> :q<CR>

" Open veritical window...
let g:miniBufExplVSplit = 30
let g:miniBufExplMaxSize = 50
let g:miniBufExplMinSize = 30

" better highlights in MBE explorer window
hi MBENormal                                                            ctermfg=038 guifg=#80a0ff
hi MBECHanged                                                           ctermfg=210 guifg=Orange
hi MBEVisibleNormal         term=bold,underline cterm=underline         ctermfg=038 guifg=#ff80ff
hi MBEVisibleChanged        term=bold,underline cterm=underline         ctermfg=210 guifg=Orange
hi MBEVisibleActiveNormal   term=bold,underline cterm=bold,underline    ctermfg=159 guifg=#ff80ff
hi MBEVisibleActiveChanged  term=bold,underline cterm=bold,underline    ctermfg=224 guifg=Orange
" }]

" CCTree: load cscope.out on startup, if available {[
" if filereadable('cscope.out')
"     autocmd VimEnter * CCTreeLoadDB cscope.out
" endif
" }]

" VimCalc configurations [{
" open VimCalc on right side
let g:VCalc_WindowPosition = 'right'
" default size (10) is too small
let g:VCalc_Win_Size = 20
" open calc with <Leader>C (\C)
nnoremap <Leader>C  :Calc<CR>
" }]

" change color scheme for diff instances (default is toooooooooooo loud) [{
if &diff
    colorscheme railscasts
endif
" }]

" Miscellaneous [{
" Misc highlight groups
hi MiscLineHighlight    ctermfg=0 ctermbg=121 guibg=LightGreen

" Highlight current line
nnoremap <Leader>h :call matchadd("MiscLineHighlight", '\%'.line('.').'l')<CR>
nnoremap <Leader>v :call matchadd("MiscLineHighlight", '\%'.virtcol('.').'v')<CR>
nnoremap <Leader>c :call clearmatches()<CR>
" }]

" vim-zoom settings [{
function ZoomMBE()
    MBEToggle
    echo "toggle"
    call zoom#toggle()
    echo "zoom"
    MBEToggle
    echo "toggle"
endfunction

" Toogle MBE before zoom otherwise MBE events stop working.
" nnoremap <C-W>z :call ZoomMBE()<CR>
" }]

" Doxygen [{
" Start the comments with /*!
let DoxygenToolkit_startCommentTag="/*!"
" }]

" ZoomWin [{
function MyZoomWin()
    MBEToggle
    echo "toggle"
    ZoomWin
    echo "zoom"
    MBEToggle
    echo "toggle"
endfunction

" set mapping
nnoremap <silent> <C-w>z :ZoomWin<CR>
" }]

" MultipleSearch settings [{
let g:MultipleSearchMaxColors = 8
let g:MultipleSearchColorSequence = "red,blue,green,magenta,cyan,gray,brown"
let g:MultipleSearchTextColorSequence = "black,white,black,black,black,black,white"
" }]

" Don't conceal JSON [{
let g:vim_json_conceal = 0
" }]

" Use vim-jsonc for JSON [{
autocmd BufNewFile,BufRead *.json set syntax=jsonc
" }]

" Use 2-space indentation in JSON [{
autocmd BufNewFile,BufRead *.json setlocal shiftwidth=2
autocmd BufNewFile,BufRead *.json setlocal tabstop=2
autocmd BufNewFile,BufRead *.json setlocal softtabstop=2
" }]
