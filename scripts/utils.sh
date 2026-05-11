#!/bin/bash

is_installed() {
  rpm -qi "$1" &>/dev/null
}

is_group_installed() {
  dnf group list --installed hidden ids 2>/dev/null \
    | grep -Fxq "$1"
}

install_packages() {
  local packages=("$@")
  local to_install=()

  for pkg in "${packages[@]}"; do
    if [[ "$pkg" == @* ]]; then
      local group="${pkg#@}"

      if ! is_group_installed "$group"; then
        to_install+=("$pkg")
      fi
    else
      if ! is_installed "$pkg"; then
        to_install+=("$pkg")
      fi
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "Installing: ${to_install[*]}"
    sudo dnf install "${to_install[@]}"
  fi
}
