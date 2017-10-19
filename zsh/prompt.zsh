#####################
# Set up the prompt #
#####################
#
# Useful utf characters: λ ✔ ✓ ✘ ✢ ➤ ✖ ❯ ❮ ✚ ✹ ➜ ═ ✭  ▶

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
    local _host_str='%B%K{blue}%F{yellow}%n@%m:'
elif over_ssh; then
    local _host_str='%B%K{blue}%F{white}%n@%m:'
elif [ -n "${TMUX}" ]; then
    local _host_str='%B%K{green}%F{yellow}%n@%m:'
else
    local _host_str='%B%K{green}%F{white}%n@%m:'
fi

# Setup Git information
# autoload -Uz vcs_info
# precmd_vcs_info() { 
# 	vcs_info 
# }
# precmd_functions+=( precmd_vcs_info )
 
# zstyle ':vcs_info:git+post-backend:*' hooks git-count-commits-ahead
# +vi-git-count-commits-ahead() {
# 	hook_com[branch]+="↑"
# 	hook_com[branch]+=`git rev-list --count origin/master...@`
# }

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
PROMPT_SEPARATOR=""
#◢
# PROMPT_SEPARATOR=" ❯❯❯"
PROMPT="
${_host_str}${PROMPT_SEPARATOR}%S${_current_path}${PROMPT_SEPARATOR}%s%k%b%f ${_git_info}"
PROMPT="${PROMPT}${_newline}%B${_status}%b"

# In the right we just want the time/date
RPROMPT="%{${_lineup}%}%{${_lineup}%}${_vim_mode}%F{white}%K{black} %w - %T%f%k%{${_linedown}%}%{${_linedown}%}"
