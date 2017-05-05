############
# Setmeup:
# --------
# 
# Removes existing configuration
# Replaces it with symbolic links to the configurations in the git repo
# Sets up vim/neo-vim and the extensions
# Makes sure zsh is the default
CPY='ln -sf'
CPY='cp'

# Remove existing configs
echo '\n** Preparing install **'
rm $HOME/.tmux.conf
rm $HOME/.zshrc
rm $HOME/.vimrc
rm $HOME/.gitconfig
rm $HOME/.pypirc
rm -rf $HOME/.config/nvim/
rm -rf $HOME/.vim

# Copy conf files (symlinks)
$CPY $PWD/tmux.conf $HOME/.tmux.conf
$CPY $PWD/pypirc $HOME/.pypirc
$CPY $PWD/zshrc $HOME/.zshrc
$CPY $PWD/vimrc $HOME/.vimrc
$CPY $PWD/gitconfig $HOME/.gitconfig

# Add alias for scripts
echo "alias mkpdf='$PWD/scripts/compile_latex.sh'" >> $HOME/.local_zshrc
echo "alias notebook='$PWD/scripts/notebook.sh'" >> $HOME/.local_zshrc
echo "alias pycharm='$HOME/pycharm-2016.2.3/bin/pycharm.sh &'" >> $HOME/.local_zshrc

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
$CPY $PWD/settings.vim $HOME/.vim/settings.vim
$CPY $PWD/keybindings.vim $HOME/.vim/keybindings.vim
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
# Modify the default docstring
echo "$text" > $HOME/.vim/plugged/vim-pydocstring/template/pydocstring/multi.txt

# Neo-vim configuration
echo '\n** Configuring neo-vim **'
mkdir -p $HOME/.config/nvim
$CPY $PWD/nvimrc $HOME/.config/nvim/init.vim
$CPY $PWD/settings.vim $HOME/.config/nvim/settings.vim
$CPY $PWD/keybindings.vim $HOME/.config/nvim/keybindings.vim
curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qall
# Modify the default docstring
echo "$text" > $HOME/.config/nvim/plugged/vim-pydocstring/template/pydocstring/multi.txt

# If zsh is not default, make it the default
ZSH_BIN_PATH=`which zsh`
echo "\n** Checking you are using the correct shell.. **."
# if [ -n "$ZSH_VERSION"];
if [[ -n "${ZSH_VERSION/[ ]*\n/}" ]]
then
    echo "   # Good, you are already using zsh"
else
    echo "   # Current shell is not zsh, changing it. Please enter password."
	if [[ `uname` == 'Linux' ]]; then
		chsh -s ${ZSH_BIN_PATH}
	elif [[ `uname` == 'Darwin' ]]; then
		echo "${ZSH_BIN_PATH}" | sudo tee -a /etc/shells > /dev/null
		chsh -s ${ZSH_BIN_PATH}
	fi
fi

# Yay!
echo '\n\n*** Congratulations! You are all set up!! ***\n'
