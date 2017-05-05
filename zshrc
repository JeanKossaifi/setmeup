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
        # Remap CAPS LOCK to Escape
        alias ls="ls --color=auto"
        export PLATFORM="linux"

    elif [[ `uname` == 'Darwin' ]]; then
        alias ls="ls -G"
        export PLATFORM="osx"
        export PATH=$HOME/anaconda3/bin:$PATH
        export PYTHONPATH=$HOME/mxnet//python:$HOME/anaconda3/bin:$PYTHONPATH
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
export PATH=$HOME/anaconda3/bin:$PATH
export PYTHONPATH=$HOME/mxnet//python:$HOME/anaconda3/bin:$PYTHONPATH

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


# source $HOME/.aliases


#####################
#      Aliases      #
#####################
alias mkdir='nocorrect mkdir'

# Suffix aliases (match the end)
# e.g. typing test.py will execute python test.py
alias -s py="python"
alias -s tex="mkpdf -vs -n"
# alias -s unpushed="!GIT_CURRENT_BRANCH=$(git name-rev --name-only HEAD) && git log origin/$GIT_CURRENT_BRANCH..$GIT_CURRENT_BRANCH --oneline"

###################
# CUSTOM COMMANDS #
###################

# Python path
export VISUAL="vim"
export EDITOR="vim"
export BROWSER="google-chrome"
export PAGER="less"

#####################
#  History config   #
#####################

setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Shared history, no duplicates
setopt histignorealldups sharehistory 
# don't wait exit to add to hist
setopt inc_append_history

# A better way?
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${_KEY_UP}" up-line-or-beginning-search
bindkey "${_KEY_DOWN}" down-line-or-beginning-search
# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward

# make search up and down work, so partially type and hit up/down to find relevant stuff
# bindkey '^[OA' up-line-or-search                                                
# bindkey '^[OB' down-line-or-search


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

######################
#     Nicer colors   #
######################

# Colors for ls
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
export LS_COLORS

# coloured manuals
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

#####################
# Set up completion #
#####################

# Use modern completion system
autoload -Uz compinit
compinit

# Turn on command substitution in the prompt (and parameter expansion and arithmetic expansion
setopt promptsubst

# Automatically update new executables in $PATH
zstyle ':completion:*' rehash true

# Activate navigation in the completion menu
zstyle ':completion:*' menu select

# Control+enter to complete from completion menu and execute resulting line
zmodload zsh/complist
bindkey -M menuselect "${_KEY_CTRL_ENTER}" .accept-line

# Use shifttab to go backward in the completion menu
bindkey "${_KEY_SHIFT_TAB}" reverse-menu-complete

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# autocorrection of typed commands
setopt correctall

#####################
#  WINDOW TITLE    #
#####################


case $TERM in
  termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () {
      print -Pn "\e]0;[%n@%M] opened in [%~]\a"
    } 
    preexec () { print -Pn "\e]0;[%n@%M]  opened in  [%~] ($1)\a" }
    ;;
  screen|screen-256color)
    precmd () { 
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - (%L) [%n@%M] opened in [%~]\a" 
    }
    preexec () { 
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - (%L) [%n@%M] opened in [%~] ($1)\a" 
    }
    ;; 
esac


#####################
# Set up the prompt #
#####################

# Use colors for the prompt
autoload -Uz colors && colors

# If you want a default prompt
# autoload -U promptinit
# promptinit
# prompt adam2 8bit
# alias adam2='prompt adam2 8bit'
# alias adam2-light='prompt adam2 8bit cyan black black black magenta'

# Allow for variables to be properly substituted
setopt prompt_subst

# Won't work inline
local _newline=$'\n'
local _lineup=$'\e[1A'
local _linedown=$'\e[1B'

# Indicate whether it is a local/ssh terminal or tmux session
if over_ssh && [ -n "${TMUX}" ]; then 
    local _host_str='%B%K{blue}%F{yellow}%n@%m:%S'
elif over_ssh; then
    local _host_str='%B%K{blue}%F{white}%n@%m:%S'
elif [ -n "${TMUX}" ]; then
    local _host_str='%B%K{green}%F{yellow}%n@%m:%S'
else
    local _host_str='%B%K{green}%F{white}%n@%m:%S'
fi

# Setup Git information
autoload -Uz vcs_info
precmd_vcs_info() { 
	vcs_info 
}
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:git+post-backend:*' hooks git-count-commits-ahead
+vi-git-count-commits-ahead() {
	hook_com[branch]+="↑"
	hook_com[branch]+=`git rev-list --count origin/master...@`
}
# Check the status
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{green}✓%f'
zstyle ':vcs_info:git:*' unstagedstr '%F{red}✘%f'
zstyle ':vcs_info:git:*' formats '[%r-%b]%c%u %a'
local _git_info=$'$vcs_info_msg_0_'

# This checks, whether the path is longer then 6 elements, and in that case prints the first 2 elements (%-2~), dots (/…/) and the last 3 elements.
_current_path='%(6~|%-2~/…/%3~|%5~)'

# Shorten the path if it is longer than 60 percent of the prompt (the 0.6 in there)
# _current_path='$(pwd|awk -F/ -v "n=$(tput cols)" -v "h=^$HOME" '\''{sub(h,"~");n=0.6*n;b=$1"/"$2} length($0)<=n || NF==3 {print;next;} NF>3{b=b"/../"; e=$NF; n-=length(b $NF); for (i=NF-1;i>3 && n>length(e)+1;i--) e=$i"/"e;} {print b e;}'\'')'

# This is > unless the previous command failed in which case it is (error_numer)>
# _status='%(?..%F{red}(%?%))>%f '
_status='%(?..%F{red})>%f '

# Add to prompt to display whoisconnected
# watch=all                       # watch all logins
# logcheck=30                     # every 30 seconds
# _whoishere="%n from %M has %a tty%l at %T %W"

#PROMPT="${_host_str} %~ ❯❯❯%s%k%b%f "
PROMPT="
${_host_str} ${_current_path} ❯❯❯%s%k%b%f ${_git_info}"
PROMPT="${PROMPT}${_newline}%B${_status}%b"

# In the right we just want the time/date
RPROMPT="%{${_lineup}%}${_vim_mode}❮%F{white}%K{black} %w - %T%f%k❯%{${_linedown}%}"


