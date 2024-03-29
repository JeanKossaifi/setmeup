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

if [[ `uname` == 'Darwin' ]]; then
	. ./setup_brews.sh
fi

# Remove existing configs
printf '\n** Preparing install **'
rm $HOME/.tmux.conf
rm $HOME/.zshrc
rm $HOME/.vimrc
rm $HOME/.gitconfig
rm $HOME/.pypirc
rm $HOME/.xonshrc
rm -rf $HOME/.config/nvim/
rm -rf $HOME/.vim
rm -rf $HOME/.zsh

# Copy conf files (symlinks)
$CPY $PWD/tmux/tmux.conf $HOME/.tmux.conf
$CPY $PWD/pypirc $HOME/.pypirc
$CPY $PWD/zsh/zshrc $HOME/.zshrc
$CPY $PWD/vim/vimrc $HOME/.vimrc
$CPY $PWD/gitconfig $HOME/.gitconfig
$CPY $PWD/zsh $HOME/.zsh
$CPY $PWD/xonsh/xonshrc $HOME/.xonshrc

# Add alias for scripts
touch $HOME/.local_zshrc
# echo "alias mkpdf='$PWD/scripts/compile_latex.sh'" >> $HOME/.local_zshrc
# echo "alias notebook='$PWD/scripts/notebook.sh'" >> $HOME/.local_zshrc
# echo PATH=$HOME/anaconda3/bin:$PATH >> $HOME/.local_zshrc
# echo PYTHONPATH=$HOME/anaconda3/bin:$PYTHONPATH >> $HOME/.local_zshrc

############### VIM ###############################
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

########### SETUP SHELL #####################
. ./setup_shell.sh

# Yay!
printf '\n\n*** Congratulations! You are all set up!! ***\n'

