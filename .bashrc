# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#--- Source .inputrc ---
# Apply .inputrc changes on sourcing .bashrc
bind -f ~/.inputrc

#--- Optional shell features ---
# Do not overwrite the history file
shopt -s histappend
# Updates terminal LINES and COLUMNS after each command
shopt -s checkwinsize
# cd into directory automatically
shopt -s autocd
# Save multi-line commands
shopt -s lithist
# Store multi-line commands as a single history entry
shopt -s cmdhist
# Warn before exiting if background jobs are running
shopt -s checkjobs
# Auto-correct typos in directory names
shopt -s cdspell
# Extended glob pattern matching
shopt -s extglob
# Recursive ** directory globbing
shopt -s globstar

#--- Aliases ---
alias ls="ls -X --group-directories-first --color=auto"
alias ll="ls -AlF"
alias la="ls -A"
alias l="ls -CF"
alias grep="grep --color=auto"
alias ..="cd ..;pwd"
alias ...="cd ../..;pwd"
alias ....="cd ../../..;pwd"
alias h="history"
alias c="clear"
alias r='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias kali="distrobox enter kali"

#--- History options ---
HISTTIMEFORMAT="%y-%m-%d %H:%M "
HISTCONTROL=ignoredups:erasedups:ignorespace
HISTSIZE=10000
HISTFILESIZE=10000

#--- Shell integration ---
osc7_cwd() {
    [[ -t 1 ]] || return
    printf '\e]7;file://%s%s\e\\' "${HOSTNAME:-localhost}" "$(pwd -P)"
}

#--- Append command history across sessions ---
PROMPT_COMMAND=(
    'history -a'
    'history -n'
    'osc7_cwd'
)

#--- Git prompt (__git_ps1) ---
for f in \
  /usr/share/git/completion/git-prompt.sh \
  /usr/share/git-core/contrib/completion/git-prompt.sh
do
  [[ -f $f ]] && source "$f" && break
done

#--- Source git completion ---
if [ -f /usr/share/bash-completion/completions/git ]; then
    . /usr/share/bash-completion/completions/git
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM=auto
#--- Prompt ---
if [[ -n "${CONTAINER_ID:-}" ]] &&
   [[ -e /run/.containerenv || -e /.dockerenv ]]; then
    PS1="\t (${CONTAINER_ID}) \[\033[35m\]\w\[\033[36m\]\$(__git_ps1)\[\033[0m\]\n\$ "
else
    PS1="\t \[\033[35m\]\w\[\033[36m\]\$(__git_ps1)\[\033[0m\]\n\$ "
fi

#--- User environment variables ---
export EDITOR=nvim
export SUDO_EDITOR=nvim
export VISUAL=nvim
export LESS="-RFMX --mouse --wheel-lines=3"
