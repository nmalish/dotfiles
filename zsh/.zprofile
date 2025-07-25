# Homebrew. Visit: https://brew.sh
eval "$(/opt/homebrew/bin/brew shellenv)"

# nvm (Node Version Manager) 
# visit: https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# dotnet 
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools


# source custom aliases
[ -f ~/.aliases ] && source ~/.aliases
