SHELL_NAME=zsh
# Path to xonsh
#SHELL_BIN_PATH=`which $SHELL_NAME`
# The above is not portable, see
# https://github.com/ohmyzsh/ohmyzsh/issues/3300
SHELL_BIN_PATH=$(grep /zsh$ /etc/shells | tail -1)
if [ -z "$SHELL_BIN_PATH" ]
then 
	echo "$SHELL_NAME is not in /etc/shells, trying to add it"
	echo "${SHELL_BIN_PATH}" | sudo tee -a /etc/shells > /dev/null
fi

echo "Using $SHELL_NAME in path $SHELL_BIN_PATH, current shell=$SHELL"
# If not installed, install it
printf "\n** Checking that you are using the correct shell.. **.\n"
if [ -z "$(command -v $SHELL_BIN_PATH)" ] 
then
	echo "  !!!WARNING !!!"
    echo "    $SHELL_NAME is not installed... Install it or suffer bash"
	echo "    First setup the shell and try again"
    echo "	 (you can directly run ./setup_shell.sh, no need to redo all"
	exit 1
    #pip install "xonsh[full]"
else
	echo "    $SHELL_NAME detected"
fi


# # Set as default
SYSTEM="`uname`"
echo "** Setting $SHELL_NAME as default **"
#if [ -z "$SHELL -c 'echo $SHELL_BIN_PATH'" ]
if [ "$SHELL" = "$SHELL_BIN_PATH" ];
then
    echo "    $SHELL_NAME is already the default"
else
	if [ "$SYSTEM" = 'Linux' ]; then
	   echo "   # Current shell is not zsh, changing it. Please enter password."
	   # chsh -s ${SHELL_BIN_PATH} $whoami
	   chsh -s ${SHELL_BIN_PATH}
   elif [ "`uname`" = 'Darwin' ]; then
	   echo "   # Current shell is not zsh, changing it. Please enter password."
	   chsh -s ${SHELL_BIN_PATH}
   fi
fi

# Add auto-suggestion
# echo '\n\n*** zsh auto-suggestion ***\n'
# git clone git://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
# echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.local_zshrc
# echo "bindkey '^ ' autosuggest-accept" >> ~/.local_zshrc


