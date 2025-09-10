# --- Set XDG cache and create zsh completion directory ---
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export ZSH_COMP_DIR="$XDG_CACHE_HOME/zsh/completion"
mkdir -p "$ZSH_COMP_DIR"

# --- Initialize completion system ---
autoload -Uz compinit
compinit

# --- Configure completion caching ---
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_COMP_DIR"

# --- Completion order ---
zstyle ':completion:*' completer _complete _match _correct _approximate

# --- Matching behaviour
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:correct:*' max-errors 1

# --- Sorting and grouping ---
zstyle ':completion:*' file-sort access
zstyle ':completion:*:*:git:*' sort false
zstyle ':completion:*' group-order directories executables all-files

# --- Display option ---
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' max-matches 50
zstyle ':completion:*' menu select

# --- Zsh key-bindings ---
bindkey -e
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
bindkey '^/' undo

# --- Zsh plugins ---
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Options ---
# Completion
setopt auto_cd                 # if a command isn't valid, but is a directory, cd to that dir
setopt auto_param_slash        # if completed parameter is a directory, add a trailing slash
setopt always_to_end           # place cursor at the end of the command line

# Expansion and Globbing
setopt extended_glob           # use more globbing features
setopt glob_dots               # include dotfiles when globbing
setopt no_case_glob            # Case insensitive globbing

# History
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history          # append to history file
setopt share_history           # import new commands and append typed commands to history
setopt extended_history        # write the history file in the ':start:elapsed;command' format
setopt hist_expire_dups_first  # expire a duplicate event first when trimming history
setopt hist_find_no_dups       # don't display a previously found event
setopt hist_ignore_space       # don't record an event starting with a space
setopt hist_no_store           # don't store history commands
setopt hist_reduce_blanks      # remove superfluous blanks from each command
setopt hist_verify             # don't execute immediately upon history expansion

# Correction
setopt correct                 # Autocorrect command typos
setopt correct_all             # Autocorrect file and directory names

# --- Aliases ---
alias ls='ls -X --group-directories-first --color=auto'
alias ll='ls -AlF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# Move up one parent folder
alias ..='cd ..;pwd'
# Move up two parent folders
alias ...='cd ../..;pwd'
# Move up three parent folders
alias ....='cd ../../..;pwd'
# View bash history
alias h='history'
# Clear terminal
alias c='clear'

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
--style=default \
--border \
"

# CTRL-Y to copy the command into clipboard using wl-copy
export FZF_CTRL_R_OPTS="
    --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
    --color header:italic
    --header 'Press CTRL-Y to copy command into clipboard'"

# Preview file content using bat
export FZF_CTRL_T_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'tree {}'"

# Search man pages database
mansearch() {
  local man_page
  man_page=$(apropos . | sed -n 's/^\(.*)\).*/\1/p' | \
  sort -u | fzf | awk "{print \$1}")

  if [ -n "$man_page" ]; then
    man "$man_page" 2>/dev/null | bat -l man -p
  fi
}

# Query zoxide
zf() {
  local Fzf
  Fzf=$(zoxide query --list | fzf --preview='ls -AFC \
  --group-directories-first \
  --color=always {}' \
  --preview-window=down:30%:wrap)

  if [ -n "$Fzf" ]; then
    z "$Fzf"
  fi
}

# Install packages from the Archlinux official repository
pac_i() {
  local selected
  selected=("${(@f)$(pacman -Slq | \
  fzf -m --preview='pacman -Si {}' \
  --preview-window=down:60%:wrap)}")
  # remove empty/null values
  selected=("${selected[@]:#}")
  if (( ${#selected[@]} > 0 )); then
    sudo pacman -Syu "${selected[@]}"
  fi
}

# Remove packages from the system
pac_r() {
  local selected
  selected=("${(@f)$(pacman -Qq | \
  fzf -m --preview='pacman -Qi {}' \
  --preview-window=down:60%:wrap)}")
  # remove empty/null values
  selected=("${selected[@]:#}")
  if (( ${#selected[@]} > 0 )); then
    sudo pacman -Rns "${selected[@]}"
  fi
}

# Query the Archlinux files database
pac_f() {
  local selected
  selected=$(pacman -Slq | \
  fzf -m --preview='cat <(pacman -Si {1}) <(pacman -Fl {1} | \
  awk "{print \$2}")' \
  --preview-window=down:60%:wrap)
  if [ -n "$selected" ]; then
    pacman -Si "$selected" | bat --style=grid
  fi
}

# Install packages from the Archlinux user repository
paru_i() {
  local selected
  selected=("${(@f)$(paru -Slq | \
  fzf -m --preview='paru -Si {}' \
  --preview-window=down:60%:wrap)}")
  # remove empty/null values
  selected=("${selected[@]:#}")
  if (( "${#selected[@]}" > 0 )); then
    paru -S "${selected[@]}"
  fi
}

# --- Git integration ---
if [[ -f /usr/share/git/completion/git-completion.sh ]]; then
  source /usr/share/git/completion/git-completion.sh
fi

# --- Zsh prompt ---
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '!'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' untrackedstr '?'
zstyle ':vcs_info:git:*' formats "%F{blue}(%b%F{magenta}%m%F{red}%u%F{cyan}%c%F{blue})%f"
setopt prompt_subst
PROMPT=$'%D{%H:%M:%S} %F{magenta}${PWD/#$HOME/~}%f ${vcs_info_msg_0_}\n$ '

# --- Execute shell commands ---
if command -v fzf &>/dev/null; then
  # Set fzf key-bindings and completion
  source <(fzf --zsh)
fi
if command -v zoxide &>/dev/null; then
  # Set zoxide
  eval "$(zoxide init zsh)"
fi
