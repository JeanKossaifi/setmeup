"""""""""""""""""""""""""""""""""""""""""""""""""""""
""""      General vim settings :)                """"
"""""""""""""""""""""""""""""""""""""""""""""""""""""

set encoding=utf-8

""" Map leader and escape
let mapleader=","
inoremap hh <ESC>
inoremap kj <ESC>

" Python
set tabstop=4     " a hard TAB displays as 4 columns
set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
set textwidth=79   
set expandtab     " insert spaces when hitting TABs
set shiftround    " round indent to multiple of 'shiftwidth'
set autoindent    " align the new line indent with the previous line

" for other filetypes
au BufNewFile,BufRead *.js, *.html, *.css, *.tex
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

" Enable filetype plugins
filetype indent on
filetype plugin on

" Ignore case when searching
set ignorecase
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Coloration syntaxique
syntax on

" Couleurs adaptees a un fond sombre
set background=dark
" set background=light

" Display current command
" set showcmd

" Display current position
set ruler

" set showmode

" Treat long lines as break lines
map j gj
map k gk

" Code folding
" set foldmethod=indent

" Spell checking
set spelllang=en
map <leader>ss :setlocal spell!<CR>

"enable cursor line in current window only"
augroup CursorLine
    au!
    au! VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au! WinLeave * setlocal nocursorline
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""
""""       Specific for Gui version              """"
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set guioptions-=T "toolbar (m = menu bar and r = scrollbar)
