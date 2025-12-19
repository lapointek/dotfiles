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
export FZF_DEFAULT_OPTS="
  --height 100% \
  --layout=reverse \
  --border \
  --color=fg:#908caa,bg:#191724,hl:#ebbcba
  --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
  --color=border:#403d52,header:#31748f,gutter:#191724
  --color=spinner:#f6c177,info:#9ccfd8
  --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
  "

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

# Search man pages database
man_s() {
  local man_page
  man_page=$(apropos . | sed -n 's/^\(.*)\).*/\1/p' |
    sort -u | fzf | awk "{print \$1}")

  if [ -n "$man_page" ]; then
    man "$man_page" 2>/dev/null
  fi
}

# Install packages from the Archlinux official repository
pac_i() {
  local selected
  mapfile -t selected < <(pacman -Slq |
    fzf -m --preview='pacman -Si {}' \
      --preview-window=down:60%:wrap)
  # remove empty/null values
  if ((${#selected[@]} > 0)); then
    sudo pacman -Syu "${selected[@]}"
  fi
}

# Remove packages from the system
pac_r() {
  local selected
  mapfile -t selected < <(pacman -Qq |
    fzf -m --preview='pacman -Qi {}' \
      --preview-window=down:60%:wrap)
  # remove empty/null values
  if ((${#selected[@]} > 0)); then
    sudo pacman -Rns "${selected[@]}"
  fi
}

# Install packages from the Archlinux user repository
paru_i() {
  local selected
  mapfile -t selected < <(paru -Slq |
    fzf -m --preview='paru -Si {}' \
      --preview-window=down:60%:wrap)
  # remove empty/null values
  if (("${#selected[@]}" > 0)); then
    paru -S "${selected[@]}"
  fi
}

# Query database and install packages
apt_i() {
  local selected
  mapfile -t selected < <(apt-cache pkgnames |
    fzf -m --preview='apt show {}' \
      --preview-window=down:60%:wrap)
  # remove empty/null values
  if ((${#selected[@]} > 0)); then
    sudo apt install "${selected[@]}"
  fi
}

# Remove installed packages
apt_r() {
  local selected
  mapfile -t selected < <(apt list --installed |
    awk -F/ '{print $1}' |
    fzf -m --preview='apt show {}' \
      --preview-window=down:60%:wrap)
  # remove empty/null values
  if ((${#selected[@]} > 0)); then
    sudo apt purge "${selected[@]}"
  fi
}

# --- Defualt bash prompt ---
export PS1="[\s] \t \[\033[35m\]\w\[\033[36m\]\$(GIT_PS1_SHOWUNTRACKEDFILES=1 \
  GIT_PS1_SHOWDIRTYSTATE=1 __git_ps1)\[\033[00m\]\n$ "

# --- Git integration ---
if [[ -f /usr/share/git/completion/git-completion.bash ]]; then
  source /usr/share/git/completion/git-completion.bash
fi
if [[ -f /usr/share/git/completion/git-prompt.sh ]]; then
  source /usr/share/git/completion/git-prompt.sh
fi

# --- Bash completion ---
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
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
