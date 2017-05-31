#####################
# Set up completion #
#####################
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


