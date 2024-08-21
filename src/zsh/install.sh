#!/bin/sh
set -e

if [ "$FAILONERROR" = "true" ]; then
  exit_code=1
else
  exit_code=0
fi

required_commands="zsh git"
for command in $required_commands; do
  if ! type "$command" > /dev/null 2>&1; then
    echo "Failed to activate feature 'dstockhammer/zsh':"
    echo "Unable to find $command. Please make sure it is installed."
    exit $exit_code
  fi
done

# turns out that $_REMOTE_USER_HOME can be empty.
# not sure what this means, but let's just set it.
# if this doesn't work for you, please open a ticket!
if [ -z $_REMOTE_USER_HOME ]; then
  _REMOTE_USER_HOME=/home/$_REMOTE_USER
fi

install_dir="$_REMOTE_USER_HOME/zsh"
echo "Installing feature 'dstockhammer/zsh' to $install_dir"
if ! git clone --recurse-submodules https://github.com/dstockhammer/zsh.git $install_dir; then
  echo "Failed to activate feature 'dstockhammer/zsh':"
  echo "Unable to clone https://github.com/dstockhammer/zsh.git"
  exit $exit_code
fi

echo 'source $HOME/zsh/.zshrc' > $_REMOTE_USER_HOME/.zshrc
sudo chsh -s $(which zsh) $_REMOTE_USER
