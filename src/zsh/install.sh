#!/bin/sh
set -e

if ! type zsh > /dev/null 2>&1; then
  echo "Failed to activate feature 'dstockhammer/zsh':"
  echo "Unable to find zsh. Please make sure it is installed."
  exit 1
fi

if ! type git > /dev/null 2>&1; then
  echo "Failed to activate feature 'dstockhammer/zsh':"
  echo "Unable to find git. Please make sure it is installed."
  exit 1
fi

if git clone --recurse-submodules https://github.com/dstockhammer/zsh.git $_REMOTE_USER_HOME/zsh; then
  echo "Activating feature 'dstockhammer/zsh'"
  echo 'source $HOME/zsh/.zshrc' > $_REMOTE_USER_HOME/.zshrc
  sudo chsh -s $(which zsh) $_REMOTE_USER
else
  echo "Failed to activate feature 'dstockhammer/zsh':"
  echo "Unable to clone https://github.com/dstockhammer/zsh.git"
fi
