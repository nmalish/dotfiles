## Introduction

This repository serves as my way to help me setup and maintain my Mac. It takes the effort out of installing everything manually. Everything needed to install my preferred setup of macOS is detailed in this readme. Feel free to explore, learn and copy parts for your own dotfiles. Enjoy!

## Setup

This dotfiles repository uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks for configuration files.

### Prerequisites

Install GNU Stow:
```bash
brew install stow
```

### Installation
1. Use Stow to symlink the configuration files:
```bash
stow .
```

2. Use Stow + package name to symlink specific package:
```bash
stow nvim
```

This will create symlinks in your home directory pointing to the files in this repository.

## Additional Setup

### Install Oh My Zsh
Install [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)

### Install Powerlevel10k
Install [Powerlevel10k](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#oh-my-zsh)
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

### Install Zsh Plugins
Install zsh-autosuggestions:
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

Install zsh-syntax-highlighting:
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Install Additional Tools
Eza
Install eza (better ls) - eza is a better version of ls with lots of different options:
```bash
brew install eza
```

Zoxide 
Zoxide is a replacement for cd. It remembers the directories you've been in, so you can more easily jump to them next time. Say you do cd ~/.local/share/omakub once. Next time, you can just do cd omakub, and Zoxide will take you directly there.
```bash
brew install zoxide
```

## Thanks To

I got inspiration from [Typecraft Dev](https://github.com/typecraft-dev/dotfiles) and [Dries Vints](https://github.com/driesvints/dotfiles). Also visit the [GitHub does dotfiles](https://dotfiles.github.io/) project.


In general, I'd like to thank every single one who open-sources their dotfiles for their effort to contribute something to the open-source community.
