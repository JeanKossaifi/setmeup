"""""""""""""""""""""""""""""""""""""""""""""""""""""
""""      vim-plug, to manage plugins            """"
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required

" Install vim-plug if needed
if empty(glob('~/.vim/autoload/plug.vim'))
  " set modifiable
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Add the plugins
call plug#begin('~/.vim/plugged')

    " Git plugin: Gstatus, Gedit, Gdiff
    Plug 'tpope/vim-fugitive'
    
    " gundo, displays undo tree
    Plug 'sjl/gundo.vim'
    
    " Solarized color scheme
    " Plug 'altercation/vim-colors-solarized'
    
    " Autocomplete
    Plug 'davidhalter/jedi-vim'
    
    " Nerd-tree
    Plug 'scrooloose/nerdtree'
    
    " Air-line
    Plug 'vim-airline/vim-airline'
    
    " On the flight syntax check
    Plug 'scrooloose/syntastic'
    
    " Source-code browser
    " Plug 'majutsushi/tagbar'
    
    " Auto doc-strings (on def, :Pydocstring or <C-l>)
    Plug 'heavenshell/vim-pydocstring'

    " Better indentation for Python
    Plug 'vim-scripts/indentpython.vim'

    Plug 'nvie/vim-flake8'

    " Add the 's' (surrounding) option
    " see :help surround
    Plug 'tpope/vim-surround'

call plug#end()

let g:pymode_python = 'python3'


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
" set background=dark
set background=light

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
setlocal spell spelllang=en
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""
""""       Specific keymaps for plugins          """"
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
" let g:syntastic_python_python_exe = 'python3'
" let g:syntastic_python_checkers = ['pylint']

" Pydoc: I want numpy style docstring:
" Add this to .vim/plugged/vim-pydocstring/template/pydocstring/multi.txt
"  """
"  
"  {{_indent_}}Parameters
"  {{_indent_}}----------
"  
"  {{_arg_}} : {{_lf_}}
"  {{_indent_}}Returns
"  {{_indent_}}-------
"  """

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
" Details for jedi
"
"
"    Completion <C-Space>
"    Goto assignments <leader>g (typical goto function)
"    Goto definitions <leader>d (follow identifier as far as possible, includes imports and statements)
"    Show Documentation/Pydoc K (shows a popup with assignments)
"    Renaming <leader>r
"    Usages <leader>n (shows all the usages of a name)
"    Open module, e.g. :Pyimport os (opens the os module)
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""
""""       Specific for Gui version              """"
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set guioptions-=T "toolbar (m = menu bar and r = scrollbar)
