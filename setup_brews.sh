# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "export PATH=/opt/homebrew/bin:$PATH" >> $HOME/.local_zshrc
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

brew install neovim
brew install zsh
brew install font-computer-modern
brew install node
