#! /bin/bash
clear

usage()
{
echo "*****************************************************"
cat << EOF
usage: $0 [-h?] [-c] 

A convenience script to setup your configuration
1) Removes existing configuration
2) Replaces it with symbolic links to the configurations in the git repo
3) Sets up vim/neo-vim and the extensions
4) Makes sure zsh is the default

A file '~/.local_zshrc' is created for the configuration 
    that should remain local to the current machine.

TYPICAL USE:
	$0  (this will create symbolic links to this repository)
    $0 -c (this will actually copy the configuration files)

BASIC OPTIONS:
   -h         Show this message

ADVANCED OPTIONS:
   -c         Copy the files rather than creating symbolic links.
   -a	      (AMAZON) Use this if you are setting up an EC2 instance

By Jean KOSSAIFI <jean [dot] kossaifi [at] gmail.com>
EOF
echo "*****************************************************"
}

COPY_FILES=0;
AMZ=0;
while getopts "hca" OPTION;
do
	case $OPTION in
		h|\?)
			usage
			exit 0
			;;
		c) COPY_FILES=1
			;;
		a) AMZ=1
			;;
	esac
done

if [ $COPY_FILES -eq 1 ]
then
	printf "\n** Configuration files will be copied.. **."
	CPY='cp -r'
else
	printf "\n** Configuration files will be symbolic links.. **."
	CPY='ln -sf'
fi

# Remove existing configs
printf '\n** Preparing install **'
rm $HOME/.tmux.conf
rm $HOME/.zshrc
rm $HOME/.vimrc
rm $HOME/.gitconfig
rm $HOME/.pypirc
rm -rf $HOME/.config/nvim/
rm -rf $HOME/.vim
rm -rf $HOME/.zsh

# Copy conf files (symlinks)
$CPY $PWD/tmux/tmux.conf $HOME/.tmux.conf
$CPY $PWD/pypirc $HOME/.pypirc
$CPY $PWD/zshrc $HOME/.zshrc
$CPY $PWD/vim/vimrc $HOME/.vimrc
$CPY $PWD/gitconfig $HOME/.gitconfig
$CPY $PWD/zsh $HOME/.zsh

# Add alias for scripts
echo "alias mkpdf='$PWD/scripts/compile_latex.sh'" >> $HOME/.local_zshrc
echo "alias notebook='$PWD/scripts/notebook.sh'" >> $HOME/.local_zshrc
echo PATH=$HOME/anaconda3/bin:$PATH >> $HOME/.local_zshrc
echo PYTHONPATH=$HOME/anaconda3/bin:$PYTHONPATH >> $HOME/.local_zshrc

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
printf '\n** Configuring vim **'
mkdir $HOME/.vim
$CPY $PWD/vim/settings.vim $HOME/.vim/settings.vim
$CPY $PWD/vim/keybindings.vim $HOME/.vim/keybindings.vim
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
# Modify the default docstring
echo "$text" > $HOME/.vim/plugged/vim-pydocstring/template/pydocstring/multi.txt

# Neo-vim configuration
NEOVIM_PATH=`which nvim`
if [ -z "$NEOVIM_PATH" ];
then
	printf "\nNeo-vim not installed..."
else
	printf '\n** Configuring neo-vim **'
	mkdir -p $HOME/.config/nvim
	$CPY $PWD/vim/nvimrc $HOME/.config/nvim/init.vim
	$CPY $PWD/vim/settings.vim $HOME/.config/nvim/settings.vim
	$CPY $PWD/vim/keybindings.vim $HOME/.config/nvim/keybindings.vim
	curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +PlugInstall +qall
	# Modify the default docstring
	echo "$text" > $HOME/.config/nvim/plugged/vim-pydocstring/template/pydocstring/multi.txt
fi

# If zsh is not default, make it the default
ZSH_BIN_PATH=`which zsh`
printf "\n** Checking you are using the correct shell.. **."
if [ -z "$ZSH_BIN_PATH" ];
then
	echo "ZSH is not installed... Install it or suffer bash"
elif [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ];
then
	echo "   # Good, you are already using zsh"
else
	if [[ `uname` == 'Linux' ]]; then
		if [ $AMZ -eq 1 ]
		then
			echo "   # Current shell is not zsh, changing it."
			sudo chsh ubuntu -s ${ZSH_BIN_PATH}
		else
			echo "   # Current shell is not zsh, changing it. Please enter password."
			chsh -s ${ZSH_BIN_PATH}
		fi
	elif [[ `uname` == 'Darwin' ]]; then
		echo "   # Current shell is not zsh, changing it. Please enter password."
		echo "${ZSH_BIN_PATH}" | sudo tee -a /etc/shells > /dev/null
		chsh -s ${ZSH_BIN_PATH}
	fi
fi

# Add auto-suggestion
# echo '\n\n*** zsh auto-suggestion ***\n'
# git clone git://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
# echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.local_zshrc
# echo "bindkey '^ ' autosuggest-accept" >> ~/.local_zshrc


# Yay!
printf '\n\n*** Congratulations! You are all set up!! ***\n'


