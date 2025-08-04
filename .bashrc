#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# apply .inputrc changes on sourcing .bashrc
bind -f ~/.inputrc

# requires fzf
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

HISTTIMEFORMAT='%y-%m-%d %H:%M '
HISTCONTROL=ignoredups:erasedups:ignorespace
HISTSIZE=5000
HISTFILESIZE=10000

# do not overwrite the history file upon exit of terminal session
shopt -s histappend
shopt -s checkwinsize
shopt -s autocd

# ensure command history is updated and synchronized across multiple sessions
PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -a --color=auto'
alias lla='ls -la --color=auto'
alias l='ls -CF --color=auto'
alias grep='grep --color=auto'

# Move to the parent folder.
alias ..='cd ..;pwd'
# Move up two parent folders.
alias ...='cd ../..;pwd'
# Move up three parent folders.
alias ....='cd ../../..;pwd'
# Press c to clear the terminal screen.
alias c='clear'
# Press h to view the bash history.
alias h='history'

# prompt with git functionality 
function parse_git_dirty {
  [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}

# prompt
export PS1="\n\t \[\033[32m\]\w\[\033[35m\]\$(parse_git_branch)\[\033[00m\]\n$ "

# default prompt
#PS1='[\u@\h \W]\$ '

# requires yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
