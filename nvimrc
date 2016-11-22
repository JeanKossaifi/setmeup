" Install vim-plug if needed: this is now done in the setup script
" if empty(glob('~/.config/nvim/autoload/plug.vim'))
"   " set modifiable
"   silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif

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

    " Add the 's' (surrounding) option
    " see :help surround
    Plug 'tpope/vim-surround'

    Plug 'heavenshell/vim-pydocstring'

" Add plugins to &runtimepath
call plug#end()


let g:python3_host_prog = '$HOME/anaconda3/bin/python'
let deoplete#sources#jedi#show_docstring=1
let g:deoplete#enable_at_startup = 1
"let g:deoplete#omni#input_patterns = 'python3'


let NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" Run pyFlakes on save
" autocmd BufWritePost *.py call Flake8()

" Gundo
nnoremap <F3> :GundoToggle<CR>

" Solarized
" colorscheme solarized

" Nerd-tree
map <C-n> :NERDTreeToggle<CR>

" Ignore .pyc etc 
let NERDTreeIgnore=['\.pyc$', '\~$']

" Air-line
set laststatus=2


source ~/.config/nvim/settings.vim
source ~/.config/nvim/keybindings.vim
