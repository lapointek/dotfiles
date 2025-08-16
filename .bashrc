#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- Source .inputrc ---
# Apply .inputrc changes on sourcing .bashrc
bind -f ~/.inputrc

# --- Variables ---
HISTTIMEFORMAT='%y-%m-%d %H:%M '
HISTCONTROL=ignoredups:erasedups:ignorespace
HISTSIZE=5000
HISTFILESIZE=10000

# Do not overwrite the history file upon exit of terminal session
shopt -s histappend
shopt -s checkwinsize
shopt -s autocd

# Ensure command history is updated and synchronized across multiple sessions
PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

# --- Aliases ---
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

# --- Yazi setup --- 
export EDITOR='nvim'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# --- FZF setup ---
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# Rosepine fzf theme
export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

# --- Execute shell commands ---
# Set starship prompt
eval "$(starship init bash)"
# Set zoxide
eval "$(zoxide init bash)"

