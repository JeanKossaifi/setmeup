####################################################
#
# zhrc configuration
# ==================
#
# Useful sources of informations:
# -----------------------------
# look at the archlinux wiki page
# https://github.com/MrElendig/dotfiles-alice/blob/master/.zshrc
# https://dustri.org/b/my-zsh-configuration.html
#
#
# Notes
# -----
# 1) Useful utf characters: λ ✔ ✓ ✘ ✢ ➤ ✖ ❯ ❮ ✚ ✹ ➜ ═ ✭  ▶
#
# 2) To get the key-code of any key (say KEY), in the shell:
#    Ctrl+v KEY
#
#    e.g. using ipython style prompt:
#    In  [1]: ctrl+v [up]
#    Out [1]: ^[OA
#
# 3) (CRUCIAL:) to play tetris
#    autoload -U tetris && tetris
#
# 4) To show keybindings, just type bindkey
#
#######################################################
if [[ -n "${ZSH_EXECUTED_ONCE}" ]];
then
    # this config has already been executed at least once
else
	# Executing this for the first time
    export ZSH_EXECUTED_ONCE=1
    if [[ `uname` == 'Linux' ]]; then
        alias ls="ls --color=auto"
        export PLATFORM="linux"

    elif [[ `uname` == 'Darwin' ]]; then
        alias ls="ls -G"
        export PLATFORM="osx"
        # export PATH=$HOME/anaconda/bin:$PATH
        # export PYTHONPATH=$HOME/mxnet//python:$HOME/anaconda3/bin:$PYTHONPATH
    fi
	export ZSH_BIN_PATH=`which zsh`
fi

# Execute everytime
if [[ `uname` == 'Linux' ]]; then
	alias ls="ls --color=auto"
	alias -s pdf=evince
elif [[ `uname` == 'Darwin' ]]; then
	alias ls="ls -G"
	alias -s pdf=open
fi

# Path
source $HOME/.local_zshrc
export PATH=$HOME/anaconda/bin:$PATH
export PYTHONPATH=$HOME/mxnet//python:$HOME/anaconda/bin:$PYTHONPATH

# Key maps
if [ -n "$terminfo[kcuu1]" ]; then
    local _KEY_UP="$terminfo[kcuu1]"
    local _KEY_DOWN="$terminfo[kcud1]"
else
    local _KEY_UP="^[[A"
    local _KEY_DOWN="^[[B"
fi
local _KEY_CTRL_ENTER="^J"
# Use shifttab to go backward in the completion menu
local _KEY_SHIFT_TAB="^[[Z"


#####################
#      Aliases      #
#####################
alias mkdir='nocorrect mkdir'
# alias python='ipython -i'

# Suffix aliases (match the end)
# e.g. typing test.py will execute python test.py
alias -s py="python"
alias -s tex="mkpdf -vs -n"
alias -s unpushed='!GIT_CURRENT_BRANCH=$(git name-rev --name-only HEAD) && git log origin/$GIT_CURRENT_BRANCH..$GIT_CURRENT_BRANCH --oneline'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'

###################
# CUSTOM COMMANDS #
###################

# Python path
export VISUAL="vim"
export EDITOR="vim"
export BROWSER="google-chrome"
export PAGER="less"

#####################
#  General config   #
#####################

# In case a command freezes the terminal, to avoid need for manual restart
# TODO check this
ttyctl -f

# .. equivalent to cd .. if none ambiguous
setopt AUTO_CD

# Vim-mode, escape with kj
bindkey "kj" vi-cmd-mode

#####################
# Useful functions  #
#####################

# True if connected over ssh
over_ssh() {
    if [[ -n "${SSH_CLIENT}"  ||  -n "${SSH2_CLIENT}" ]]; then 
        return 0
    else
        return 1
    fi
}


source $HOME/.zsh/colours.zsh
source $HOME/.zsh/window_title.zsh
source $HOME/.zsh/completion.zsh
source $HOME/.zsh/prompt.zsh
source $HOME/.local_zshrc
