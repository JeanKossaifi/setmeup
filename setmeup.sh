# Remove existing configs
echo '\n** Preparing install **'
rm $HOME/.tmux.conf
rm $HOME/.zshrc
rm $HOME/.vimrc
rm $HOME/.gitconfig
rm -rf $HOME/.config/nvim/
rm -rf $HOME/.vim

# Copy conf files (symlinks)
ln -sf $PWD/tmux.conf $HOME/.tmux.conf
ln -sf $PWD/zshrc $HOME/.zshrc
ln -sf $PWD/vimrc $HOME/.vimrc
ln -sf $PWD/gitconfig $HOME/.gitconfig
ln -sf $PWD/xmodmap $HOME/.xmodmap

# Add alias for scripts
echo "alias mkpdf='$PWD/scripts/compile_latex.sh'" >> $HOME/.aliases
echo "alias pycharm='$HOME/pycharm-2016.2.3/bin/pycharm.sh &'"

# For the doc vim/nvim plugin
# We want numpy docs
text='"""

{{_indent_}}Parameters
{{_indent_}}----------

{{_arg_}} : {{_lf_}}
{{_indent_}}Returns
{{_indent_}}-------
"""'

# Vim configuration
echo '\n** Configuring vim **'
mkdir $HOME/.vim
ln -sf $PWD/settings.vim $HOME/.vim/settings.vim
ln -sf $PWD/keybindings.vim $HOME/.vim/keybindings.vim
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
# Modify the default docstring
echo "$text" > $HOME/.vim/plugged/vim-pydocstring/template/pydocstring/multi.txt

# Neo-vim configuration
echo '\n** Configuring neo-vim **'
mkdir -p $HOME/.config/nvim
ln -sf $PWD/nvimrc $HOME/.config/nvim/init.vim
ln -sf $PWD/settings.vim $HOME/.config/nvim/settings.vim
ln -sf $PWD/keybindings.vim $HOME/.config/nvim/keybindings.vim
curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qall
# Modify the default docstring
echo "$text" > $HOME/.config/nvim/plugged/vim-pydocstring/template/pydocstring/multi.txt

# If zsh is not default, make it the default
ZSH_BIN_PATH=`which zsh`
echo "\n** Checking you are using the correct shell.. **."
if [ -n "$ZSH_VERSION"];
then
    echo "   # Good, you are already using zsh"
else
    echo "   # Current shell is not zsh, changing it. Please enter password."
    chsh -s ${ZSH_BIN_PATH}
fi

# Yay!
echo '\n\n*** Congratulations! You are all set up!! ***\n'
