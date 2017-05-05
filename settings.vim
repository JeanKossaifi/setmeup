"""""""""""""""""""""""""""""""""""""""""""""""""""""
""""      General vim settings :)                """"
"""""""""""""""""""""""""""""""""""""""""""""""""""""

" Uncomment this to copy/paste to clipboard
"set clipboard=unnamed

" General settings
set encoding=utf-8
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Make delete works as expected
set backspace=indent,eol,start

" Python
"    \ set foldmethod=indent|
au BufNewFile,BufRead *.py 
    \ set softtabstop=4    |
    \ set shiftwidth=4     |
    \ set expandtab	       |
    \ set autoindent       |
    \ set fileformat=unix  |
    \ set encoding=utf-8   
"    \ set textwidth=79     |

" for Restructured Text
au BufNewFile,BufRead *.rst
    \ set tabstop=3        |
    \ set softtabstop=3    |
    \ set shiftwidth=3     |
    \ set expandtab

" for other filetypes
au BufNewFile,BufRead *.js, *.html, *.css, *.tex
    \ set tabstop=2        |
    \ set softtabstop=2    |
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
syntax enable

" Set color depending on background
" set background=dark
set background=light

" Display current command
" set showcmd

" Display current position
set ruler

" set showmode

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
