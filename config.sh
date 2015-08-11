#!/bin/sh

# config.sh
# Author: Kevin Schaich
# schaich.kevin@gmail.com

# Instructions:
# To Run, execute:
# curl -L https://raw.githubusercontent.com/kevinschaich/dotfiles/master/config.sh | sh

echo "Installing Homebrew..."
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Updating Homebrew..."
brew doctor
brew update

echo "Installing terminal utilities..."
brew install zsh
brew install zsh-completions
brew install zsh-history-substring-search
brew install zsh-completions
brew install zsh-syntax-highlighting
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

echo "Installing applications/utilities/tools..."
brew cask install atom
brew cask install qlcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install quicklook-csv

echo "Cleaning up..."
brew cleanup

echo "Installing oh-my-zsh..."
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

cd ~
###############################################################################
# Setup symlinks for .dotfiles
###############################################################################

echo "Setting up symlinks..."
cd ~ && git clone https://github.com/kevinschaich/dotfiles/ && cd dotfiles

ln -sfF ~/dotfiles/.atom ~
ln -sfF ~/dotfiles/.bashrc ~
ln -sfF ~/dotfiles/.bash_profile ~
ln -sfF ~/dotfiles/.iterm2 ~
ln -sfF ~/dotfiles/.inputrc ~
ln -sfF ~/dotfiles/.vimrc ~
ln -sfF ~/dotfiles/.zshrc ~
sudo cp ~/dotfiles/dark.terminal /Applications/Utilities/Terminal.app/Contents/Resources/Initial\ Settings/

###############################################################################
# Kill affected applications
###############################################################################

cecho "Done!" $cyan
cecho "################################################################################" $white
cecho "Note that some of these changes require a logout/restart to take effect." $red
cecho "Killing some open applications in order to take effect." $red

find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
  "Transmission"; do
  killall "${app}" > /dev/null 2>&1
done
