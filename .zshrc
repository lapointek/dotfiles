# --- Completion configuration ---
# Set XDG cache and create zsh completion directory
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export ZSH_COMP_DIR="$XDG_CACHE_HOME/zsh/completion"
mkdir -p "$ZSH_COMP_DIR"

# Initialize completion system
autoload -Uz compinit
compinit

# Configure completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_COMP_DIR"

# Completion order
zstyle ':completion:*' completer _complete _match _correct _approximate

# Matching behaviour
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:correct:*' max-errors 1

# Sorting and grouping
zstyle ':completion:*' file-sort access
zstyle ':completion:*:*:git:*' sort false
zstyle ':completion:*' group-order directories executables all-files

# Display option
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' max-matches 50
zstyle ':completion:*' menu select

# --- User environment variables ---
# Editors
export EDITOR=nvim
export SUDO_EDITOR=nvim
export VISUAL=nvim
# Pager
export LESS="-RFMX --mouse --wheel-lines=3"
# Bat theme
export BAT_THEME=ansi

if [[ -f ~/.env ]] &>/dev/null; then
  set -a
  source ~/.env
  set +a
fi

# --- Zsh key-bindings ---
bindkey -e
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
bindkey '^/' undo

# --- Zsh plugins Archlinux ---
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --- Zsh plugins Debian ---
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --- Source nvm ---
if [[ -f /usr/share/nvim/init-nvm.sh ]]; then
  source /usr/share/nvm/init-nvm.sh
fi

# --- Options ---
# Completion
setopt auto_cd                 # if a command isn't valid, but is a directory, cd to that dir
setopt auto_param_slash        # if completed parameter is a directory, add a trailing slash
setopt always_to_end           # place cursor at the end of the command line

# Expansion and Globbing
setopt extended_glob           # use more globbing features
setopt glob_dots               # include dotfiles when globbing
setopt no_case_glob            # case insensitive globbing

# History
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history          # append to history file
setopt inc_append_history      # record each command immediately
setopt share_history           # import new commands and append typed commands to history
setopt extended_history        # write the history file in the ':start:elapsed;command' format
setopt hist_expire_dups_first  # expire a duplicate event first when trimming history
setopt hist_find_no_dups       # don't display a previously found event
setopt hist_ignore_dups        # prevent consecutive duplicates
setopt hist_ignore_space       # don't record an event starting with a space
setopt hist_no_store           # don't store history commands
setopt hist_reduce_blanks      # remove superfluous blanks from each command
setopt hist_verify             # don't execute immediately upon history expansion

# Correction
setopt correct                 # autocorrect command typos
setopt correct_all             # autocorrect file and directory names

# --- Aliases ---
alias ls='ls -X --group-directories-first --color=auto'
alias ll='ls -AlF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias llama3='ollama run llama3.1'
alias gemma3='ollama run gemma3:12b'
alias omnipotent='ollama run omnipotent'

# Move up one parent folder
alias ..='cd ..;pwd'
# Move up two parent folders
alias ...='cd ../..;pwd'
# Move up three parent folders
alias ....='cd ../../..;pwd'
# View zsh history
alias h='history -E'
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

# Preview file content using bat
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
  man_page=$(apropos . | sed -n 's/^\(.*)\).*/\1/p' | \
  sort -u | fzf | awk "{print \$1}")

  if [ -n "$man_page" ]; then
    man "$man_page"
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

# Query database and install packages
apt_i() {
  local selected
  selected=("${(@f)$(apt-cache pkgnames | \
  fzf -m --preview='apt show {}' \
  --preview-window=down:60%:wrap)}")
  # remove empty/null values
  selected=("${selected[@]:#}")
  if (( ${#selected[@]} > 0 )); then
    sudo apt install "${selected[@]}"
  fi
}

# Remove installed packages
apt_r() {
  local selected
  selected=("${(@f)$(apt list --installed | \
  awk -F/ '{print $1}' | \
  fzf -m --preview='apt show {}' \
  --preview-window=down:60%:wrap)}")
  # remove empty/null values
  selected=("${selected[@]:#}")
  if (( ${#selected[@]} > 0 )); then
    sudo apt purge "${selected[@]}"
  fi
}

# --- Zsh prompt ---
autoload -Uz vcs_info
# Enable vcs_info
precmd() { vcs_info }
# Zstyle git settings
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '!'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '%F{cyan}%b%f%F{red}%u%f%F{cyan}%c%f %F{blue}%m%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-st
# Enable prompt substitution
setopt prompt_subst

if [[ -n "${CONTAINER_ID:-}" ]]; then
  PROMPT_PREFIX="(${CONTAINER_ID})"
fi

# Prompt
PROMPT=$'%D{%H:%M:%S} $PROMPT_PREFIX %F{magenta}${PWD/#$HOME/~}%f ${vcs_info_msg_0_}\n$ '

# Show untracked
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep -q '^?? ' 2> /dev/null ; then
        hook_com[unstaged]+='?'
    fi
}

# Show ahead and behind
function +vi-git-st() {
    local ahead behind
    local -a gitstatus

    # Exit early in case the worktree is on a detached HEAD
    git rev-parse ${hook_com[branch]}@{upstream} >/dev/null 2>&1 || return 0

    local -a ahead_and_behind=(
        $(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null)
    )

    ahead=${ahead_and_behind[1]}
    behind=${ahead_and_behind[2]}

    (( $ahead )) && gitstatus+=( "↑${ahead}" )
    (( $behind )) && gitstatus+=( "↓${behind}" )

    hook_com[misc]+=${(j:/:)gitstatus}
}

# --- Execute shell commands ---
# Set up fzf key bindings and fuzzy completion
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi
# Zoxide
if command -v zoxide &>/dev/null; then
  # Set zoxide
  eval "$(zoxide init zsh)"
fi
