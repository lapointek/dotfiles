# --- Zsh completion ---
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate _match
zstyle ':completion:*' list-colors 'di=34:fi=0:ln=36:pi=33:so=35:do=34:bd=33:cd=33:or=31:mi=31:ex=32'
zstyle ':completion:*' max-matches 50
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit

# --- Zsh key-bindings ---
bindkey -e
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
bindkey '^/' undo

# --- Zsh plugins ---
source ~/.config/zsh/fsh/fast-syntax-highlighting.plugin.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- Options ---
# Completion
setopt auto_cd                 # if a command isn't valid, but is a directory, cd to that dir
setopt auto_list               # automatically list choices on ambiguous completion
setopt auto_param_slash        # if completed parameter is a directory, add a trailing slash
setopt complete_in_word        # complete from both ends of a word
unsetopt menu_complete         # don't autoselect the first completion entry

# Expansion and Globbing
setopt extended_glob           # use more awesome globbing features
setopt glob_dots               # include dotfiles when globbing
setopt no_case_glob            # Case insensitive globbing

# History
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=5000
SAVEHIST=10000
setopt append_history          # append to history file
setopt share_history           # Import new commands and append typed commands to history
setopt extended_history        # write the history file in the ':start:elapsed;command' format
setopt hist_expire_dups_first  # expire a duplicate event first when trimming history
setopt hist_find_no_dups       # don't display a previously found event
setopt hist_ignore_all_dups    # delete an old recorded event if a new event is a duplicate
setopt hist_ignore_dups        # don't record an event that was just recorded again
setopt hist_ignore_space       # don't record an event starting with a space
setopt hist_no_store           # don't store history commands
setopt hist_reduce_blanks      # remove superfluous blanks from each command line being added to the history list
setopt hist_save_no_dups       # don't write a duplicate event to the history file
setopt hist_verify             # don't execute immediately upon history expansion

# Correction
setopt correct               # Autocorrect command typos
setopt correct_all           # Autocorrect file and directory names

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
    man "$man_page" 2>/dev/null | bat -l man -p
  fi
'

# fzf search Archlinux repository
alias pacman-i="sudo pacman -S \$(pacman -Sl | awk '{print \$2}' | fzf -m --preview='pacman -Si {}' --preview-window=up:60%:wrap)"
alias pacman-r="sudo pacman -Rns \$(pacman -Q | awk '{print \$1}' | fzf -m --preview='pacman -Qi {}' --preview-window=up:60%:wrap)"

# fzf search Archlinux user repository
alias paru-i="paru -S \$(paru -Sl | awk '{print \$2}' | fzf -m --preview='paru -Si {}' --preview-window=up:60%:wrap)"
alias paru-r="paru -Rns \$(paru -Q | awk '{print \$1}' | fzf -m --preview='paru -Qi {}' --preview-window=up:60%:wrap)"

# --- Git integration ---
if [[ -f /usr/share/git/completion/git-completion.sh ]]; then
  source /usr/share/git/completion/git-completion.sh
fi
if [[ -f /usr/share/git/completion/git-prompt.sh ]]; then
  source /usr/share/git/completion/git-prompt.sh
fi

# --- Bash completion ---
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
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
