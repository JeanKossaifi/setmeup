" Install vim-plug if needed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  " set modifiable
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Add the plugins
call plug#begin('~/.config/nvim/plugged')
" Make sure you use single quotes

    " Using neovim async
    Plug 'neomake/neomake'
    Plug 'Shougo/deoplete.nvim'
    Plug 'zchee/deoplete-jedi'

    " On-demand loading
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    
    " Autocomplete
    " Plug 'davidhalter/jedi-vim'
    
    " Air-line
    Plug 'vim-airline/vim-airline'
    
    " Better indentation for Python
    Plug 'vim-scripts/indentpython.vim'
    
    " gundo, displays undo tree
    Plug 'sjl/gundo.vim'

    " Git plugin: Gstatus, Gedit, Gdiff
    Plug 'tpope/vim-fugitive'

" Add plugins to &runtimepath
call plug#end()


let g:python3_host_prog = '/homes/jk712/anaconda3/bin/python'
let deoplete#sources#jedi#show_docstring=1
let g:deoplete#enable_at_startup = 1
"let g:deoplete#omni#input_patterns = 'python3'


"""""""""""""""""""""""""""""""""""""""""""""""""""""
""""      Start of the real VIMRC                """"
"""""""""""""""""""""""""""""""""""""""""""""""""""""

set encoding=utf-8

""" Map leader and escape
let mapleader=","
inoremap hh <ESC>

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
""""             Custom keymaps                  """"
"""""""""""""""""""""""""""""""""""""""""""""""""""""

" Press spacebar to getout of the highlighted search and clear all displayed messages
nnoremap <silent> <Space> : silent noh <Bar> echo <CR>

" Launch the code in ipython
nnoremap <silent><F5> :!ipython -i %" <CR>
" nnoremap <silent><C-F5> :!ipython -i % <CR>

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

" Run pyFlakes on save
" autocmd BufWritePost *.py call Flake8()

" Gundo
nnoremap <F3> :GundoToggle<CR>

" Solarized
" colorscheme solarized

" Nerd-tree
map <C-n> :NERDTreeToggle<CR>

" Air-line
set laststatus=2
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""
""""       Specific for Gui version              """"
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set guioptions-=T "toolbar (m = menu bar and r = scrollbar)
