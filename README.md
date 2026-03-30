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

# Development Environment Setup

The script automates the setup of my personal development environment on Arch Linux. It installs system utilities, development tools, and configures services.

## Features

-   Automated system update
-   Auto detect and skip preinstalled packages
-   Installation of the Paru AUR helper
-   Update of user directories and mirror list
-   Package installation:
    -   System utilities
    -   Desktop applications
    -   Development utilities
    -   Fonts
    -   Media application
    -   Office application

### Requirements

    - Arch Linux installation
    - KDE Plasma installation with archinstall

1. Run the install script.

```
./install.sh
```

2. Follow the script prompts.

3. Reboot system.
