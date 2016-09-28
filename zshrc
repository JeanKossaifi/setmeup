###################
#
# zhrc configuration
# ==================
#
# Useful sources of informations:
# -----------------------------
# look at the archlinux wiki page
# https://github.com/MrElendig/dotfiles-alice/blob/master/.zshrc
#
#
# Notes
# -----
# 1) Useful utf characters: λ ✔ ✓ ✘ ✢ ➤ ✖ ❯ ❮ ✚ ✹ ➜ ═ ✭ 
#
# 2) To get the key-code of any key (say KEY), in the shell:
#    Ctrl+v KEY
#
#    e.g. using ipython style prompt:
#    In  [1]: ctrl+v [up]
#    Out [1]: ^[OA
###################

if [[ -n "${ZSH_EXECUTED_ONCE}" ]];
then
    # this config has already been executed at least once
else
    export ZSH_EXECUTED_ONCE=1
    if [[ `uname` == 'Linux' ]]; then
        alias ls="ls --color=auto"
        export PLATFORM="linux"
        export PATH=$HOME/anaconda3/bin:$PATH
        # Key maps
        local _KEY_UP="$terminfo[kcuu1]"
        local _KEY_DOWN="$terminfo[kcud1]"

        # Remap CAPS LOCK to Escape
        # setxkbmap -option caps:escape

        # Remap CAPS LOCK to CTRL
        setxkbmap -option ctrl:nocaps

        # To reset: 
        # setxkbmap -option
    fi

    if [[ `uname` == 'Darwin' ]]; then
        alias ls="ls -G"
        export PLATFORM="osx"
        export PATH=$HOME/anaconda/bin:$PATH
        # Key maps
        local _KEY_UP="^[[A"
        local _KEY_DOWN="^[[B"
    fi
fi

local _KEY_CTRL_ENTER="^J"
# Use shifttab to go backward in the completion menu
local _KEY_SHIFT_TAB="^[[Z"

###################
# CUSTOM COMMANDS #
###################

# VARIABLES

# Python path
export VISUAL="vim"
export EDITOR="vim"
export BROWSER="google-chrome"
export PAGER="less"

# ALIASES

# Pycharm
alias pycharm='$HOME/pycharm_2016-2/bin/pycharm.sh &'

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
ttyctl -f

# Colors for ls
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
export LS_COLORS


#####################
# Useful functions  #
#####################

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
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:git:*' formats '%b'

# Indicate whether local/ssh/tmux then user-name (%n) then short host (machine = %m) then 
# Then add current directory (%~)

#_current_path='%(5~|%-1~/…/%3~|%4~)'
# This checks, whether the path is longer then 5 elements, and in that case prints the first element (%-1~), some dots (/…/) and the last 3 elements. It is not exactly the same as paths, that are not in your home directory, will also have the first element at the beginning, while bash just prints dots in that case. So

# Shorten the path if it is longer than 60 percent of the prompt (the 0.6 in there)
_current_path='$(pwd|awk -F/ -v "n=$(tput cols)" -v "h=^$HOME" '\''{sub(h,"~");n=0.6*n;b=$1"/"$2} length($0)<=n || NF==3 {print;next;} NF>3{b=b"/../"; e=$NF; n-=length(b $NF); for (i=NF-1;i>3 && n>length(e)+1;i--) e=$i"/"e;} {print b e;}'\'')'


#PROMPT="${_host_str} %~ ❯❯❯%s%k%b%f "
PROMPT="${_host_str} ${_current_path} ❯❯❯%s%k%b%f \$vcs_info_msg_0_"
PROMPT="${PROMPT}${_newline}%B> %b"

# In the right we just want the time/date
RPROMPT="%{${_lineup}%}❮%F{white}%K{black} %w - %T%f%k❯%{${_linedown}%}"

