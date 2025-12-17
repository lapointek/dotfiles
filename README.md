# My dotfiles

This directory contains my dotfiles and automated install scripts for my system.

## Installation

### Requirements

```
- GNU Stow
- Git
```

1. Clone this repository into your $HOME directory:

```
$ git clone https://github.com/lapointek/dotfiles.git

cd dotfiles
```

2. Then use GNU stow in the root of the dotfiles directory to create the symlinks.

```
stow .
```

## Archlinux Only

### Requirements

    - Arch Linux installation

1. Run the install script.

```
./install.sh
```

2. Follow the script prompts.

3. Reboot system.
   `
