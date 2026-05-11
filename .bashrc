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
HISTSIZE=10000
HISTFILESIZE=10000

# --- User environment variables ---
# Editors
export EDITOR=nvim
export SUDO_EDITOR=nvim
export VISUAL=nvim
# Pager
export LESS="-RFMX --mouse --wheel-lines=3"
# Bat theme
export BAT_THEME=ansi

# Ensure command history is updated and synchronized across multiple sessions
PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

# --- Optional shell features ---
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
# Detect and fix typo during completion
shopt -s dirspell
# Replace your input with the corrected full path
shopt -s direxpand

# Case insensitive tab completion
bind 'set completion-ignore-case on'
# Show matches immediately
bind 'set show-all-if-ambiguous on'
# Cycle through completions
bind 'TAB:menu-complete'

# --- Aliases ---
alias ls="ls -X --group-directories-first --color=auto"
alias ll="ls -AlF"
alias la="ls -A"
alias l="ls -CF"
alias grep="grep --color=auto"
alias tbx="toolbox enter"
alias r="ranger"

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

# -- Shell integration ---
osc7_cwd() {
    [[ -t 1 ]] || return
    printf '\e]7;file://%s%s\e\\' "${HOSTNAME:-localhost}" "$(pwd -P)"
}

PROMPT_COMMAND="history -a; history -n"
PROMPT_COMMAND="$PROMPT_COMMAND; osc7_cwd"

# --- Fzf commands ---
# Default options
export FZF_DEFAULT_OPTS="
--height 100% \
--layout=reverse \
--border"

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

# Zoxide fzf - command 'zi'
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS"

# --- Git integration ---
if [[ -f /usr/share/git/completion/git-completion.bash ]]; then
  source /usr/share/git/completion/git-completion.bash
fi
if [[ -f /usr/share/git/completion/git-prompt.sh ]]; then
  source /usr/share/git/completion/git-prompt.sh
fi
if [[ -f /usr/lib/git-core/git-sh-prompt ]]; then
  source /usr/lib/git-core/git-sh-prompt
fi
if [[ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]]; then
  source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

# --- Bash completion ---
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
fi
if [[ -f /usr/share/bash-completion/completions/git ]]; then
  source /usr/share/bash-completion/completions/git
fi

if [[ -n "${CONTAINER_ID:-}" && (-e /run/.containerenv || -e /.dockerenv) ]]; then
  PS1="\t (${CONTAINER_ID}) \[\033[35m\]\w\[\033[36m\]\$(GIT_PS1_SHOWUNTRACKEDFILES=1 \
    GIT_PS1_SHOWDIRTYSTATE=1 __git_ps1)\[\033[00m\]\n$ "
else
  PS1="\t \[\033[35m\]\w\[\033[36m\]\$(GIT_PS1_SHOWUNTRACKEDFILES=1 \
    GIT_PS1_SHOWDIRTYSTATE=1 __git_ps1)\[\033[00m\]\n$ "
fi

# --- Execute shell commands ---
# Set up fzf key bindings and fuzzy completion
if command -v fzf &>/dev/null; then
  eval "$(fzf --bash)"
fi
# Zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
fi

# opencode
export PATH=/home/kevin/.opencode/bin:$PATH
