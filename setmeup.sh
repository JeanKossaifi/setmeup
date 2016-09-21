echo '\nPreparing install'
rm ~/.tmux.conf
rm ~/.zshrc
rm ~/.vimrc
rm ~/.config/nvim/init.vim
rm -rf ~/.config/zsh
rm -rf ~/,vim

ln -sf $PWD/tmux.conf ~/.tmux.conf
ln -sf $PWD/zshrc ~/.zshrc
ln -sf $PWD/vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -sf $PWD/nvimrc ~/.config/nvim/init.vim

echo '\nConfiguring vim'
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

echo '\nConfiguring neo-vim'
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qall

text='"""

{{_indent_}}Parameters
{{_indent_}}----------

{{_arg_}} : {{_lf_}}
{{_indent_}}Returns
{{_indent_}}-------
"""'
echo "$text" > ~/.vim/plugged/vim-pydocstring/template/pydocstring/multi.txt
echo "$text" > ~/.config/nvim/plugged/vim-pydocstring/template/pydocstring/multi.txt

echo '\n\n**Congratulations! You are all set up!!**\n'
