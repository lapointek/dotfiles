# My dotfiles

This directory contains the and automated install scripts for my system.

## Requiremenets

### Install Script

run install Script

```
$ ./install.sh
```

### Git

```
$ pacman -S git
```

### Stow

```
$ pacman -S stow
```

## Installation

1. Clone the dotfiles repo into your $HOME directory using git.

```
$ git clone https://github.com/lapointek/dotfiles.git

cd dotfiles
```

2. Then use GNU stow in the root of the dotfiles directory to create the symlinks.

```
stow .
```
