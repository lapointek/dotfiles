#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- Source .inputrc ---
# Apply .inputrc changes on sourcing .bashrc
bind -f ~/.inputrc

# --- History options ---
HISTTIMEFORMAT="%y-%m-%d %H:%M "
HISTCONTROL=ignoredups:erasedups:ignorespace
HISTSIZE=5000
HISTFILESIZE=10000

# Ensure command history is updated and synchronized across multiple sessions
PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

# Do not overwrite the history file
shopt -s histappend

# --- Optional shell features ---
# Updates terminal LINES and COLUMNS after each command
shopt -s checkwinsize
# cd into directory automatically
shopt -s autocd
# Auto-correct typos in directory names
shopt -s cdspell
# Save multi-line commands
shopt -s lithist
# Store multi-line commands as a single history entry
shopt -s cmdhist
# Warn before exiting if background jobs are running
shopt -s checkjobs

# --- Aliases ---
alias ls="ls -X --group-directories-first --color=auto"
alias ll="ls -AlF"
alias la="ls -A"
alias l="ls -CF"
alias grep="grep --color=auto"

# Move up one parent folder
alias ..="cd ..;pwd"
# Move up two parent folders
alias ...="cd ../..;pwd"
# Move up three parent folders
alias ....="cd ../../..;pwd"
# View bash history
alias h="history"
# Clear terminal
alias c="clear"

# --- Yazi setup ---
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd <"$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# --- Fzf commands ---
# Default options
export FZF_DEFAULT_OPTS="--height 100% --layout=default --style=minimal --border"

# CTRL-Y to copy the command into clipboard using wl-copy
export FZF_CTRL_R_OPTS="
    --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
    --color header:italic
    --header 'Press CTRL-Y to copy command into clipboard'"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'tree {}'"

# Fzf search man pages
alias mansearch='
man_page=$(apropos . | sed "s/ .*//" | sort -u | fzf --preview="man {1} 2>/dev/null" --preview-window=up:60%:wrap | awk "{print \$1}")
  if [ -n "$man_page" ]; then
    man "$man_page" | bat -l man -p
  fi
'

# fzf search Archlinux repository
alias pacman-i="sudo pacman -S \$(pacman -Sl | awk '{print \$2}' | fzf -m --preview='pacman -Si {}' --preview-window=up:60%:wrap)"
alias pacman-r="sudo pacman -Rns \$(pacman -Q | awk '{print \$1}' | fzf -m --preview='pacman -Qi {}' --preview-window=up:60%:wrap)"

# fzf search Archlinux user repository
alias paru-i="paru -S \$(paru -Sl | awk '{print \$2}' | fzf -m --preview='paru -Si {}' --preview-window=up:60%:wrap)"
alias paru-r="paru -Rns \$(paru -Q | awk '{print \$1}' | fzf -m --preview='paru -Qi {}' --preview-window=up:60%:wrap)"

# --- Git integration ---
if [[ -f /usr/share/git/completion/git-completion.bash ]]; then
    source /usr/share/git/completion/git-completion.bash
fi
if [[ -f /usr/share/git/completion/git-prompt.sh ]]; then
    source /usr/share/git/completion/git-prompt.sh
fi

# --- Bash prompt ---
export PS1="\n\t \[\033[35m\]\w\[\033[34m\]\$(GIT_PS1_SHOWUNTRACKEDFILES=1 GIT_PS1_SHOWDIRTYSTATE=1 __git_ps1)\[\033[00m\]\n$ "

# --- Bash completion ---
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

# --- Execute shell commands ---
if command -v fzf &>/dev/null; then
    # Set fzf key-bindings and completion
    eval "$(fzf --bash)"
fi
if command -v zoxide &>/dev/null; then
    # Set zoxide
    eval "$(zoxide init bash)"
fi
