## Introduction

This repository serves as my way to help me setup and maintain my Mac. It takes the effort out of installing everything manually. Everything needed to install my preferred setup of macOS is detailed in this readme. Feel free to explore, learn and copy parts for your own dotfiles. Enjoy!

Install [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)

Install [Powerlevel10k](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#oh-my-zsh)
```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```


Install zsh-autosuggestions:
`git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`
Install zsh-syntax-highlighting:
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


## Thanks To

I got inspiration from [Typecraft Dev](https://github.com/typecraft-dev/dotfiles) and [Dries Vints](https://github.com/driesvints/dotfiles). Also visit the [GitHub does dotfiles](https://dotfiles.github.io/) project.


In general, I'd like to thank every single one who open-sources their dotfiles for their effort to contribute something to the open-source community.
