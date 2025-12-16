# My dotfiles

This directory contains my dotfiles and automated install scripts for my system.

## Installation

1. Clone the dotfiles repo into your $HOME directory using git.

```
$ git clone https://github.com/lapointek/dotfiles.git

cd dotfiles
```

2. Run the install script.

```
./install.sh
```

3. Follow the script prompts.

4. Reboot system.

5. Then use GNU stow in the root of the dotfiles directory to create the symlinks.

```
stow .
```
