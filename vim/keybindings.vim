"""""""""""""""""""""""""""""""""""""""""""""""""""""
""""              Basic keymaps                  """"
"""""""""""""""""""""""""""""""""""""""""""""""""""""

""" Map leader and escape
let mapleader="\\"
" Other options: ",", "-"
" inoremap hh <ESC>
inoremap kj <ESC>

" Copy and paste from the clipboard
vnoremap <Leader>p "+p
nnoremap <Leader>p "+p
xnoremap <Leader>y "+y

" Treat long lines as break lines
map j gj
map k gk

" Press spacebar to getout of the highlighted search and clear all displayed messages
nnoremap <silent> <Space> : silent noh <Bar> echo <CR>

" Launch the code in ipython
nnoremap <silent><F5> :!ipython -i % <CR>
" nnoremap <silent><C-F5> :!ipython -i % <CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""
""""      disable and reuse arrow keys           """"
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable arrow keys
let g:elite_mode=1
" Remap them to resize splits instead
nnoremap <Up>    :resize +2<CR>
nnoremap <Down>  :resize -2<CR>
nnoremap <Left>  :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""
""""             TOOGLE keymaps                  """"
"""""""""""""""""""""""""""""""""""""""""""""""""""""

" Press F2 to display columns
let s:HitF2 = 0
nnoremap <silent> <F2> :call MapF2() <CR>

function! MapF2()
  if s:HitF2 == 0
    set number
    let s:HitF2 = 1
  else
    set nonumber
    let s:HitF2 = 0
  endif
endfunction

" F4 for PASTE MODE 
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

nnoremap <F4> :set invpaste paste?<CR>
set pastetoggle=<F4>

" Press F12 to activate spellchecker
set spelllang=en
let s:HitF12 = 0
nnoremap <silent> <F12> :call MapF12() <CR>

function! MapF12()
  if s:HitF12 == 0
    set nospell
    let s:HitF12 = 1
  else
    set spell
    let s:HitF12 = 0
  endif
endfunction

