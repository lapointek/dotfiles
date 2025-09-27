# My dotfiles

This directory contains the dotfiles for my system.

## Requiremenets

Ensure you have the following installed on your system.

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
