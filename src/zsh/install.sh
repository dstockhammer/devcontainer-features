#!/bin/sh
set -e

FAILONERROR=${FAILONERROR:-false}

# hard coded for now. make configurable if necessary.
ZSH_VOLUME_DIR=/var/zsh

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

INSTALL_DIR="$_REMOTE_USER_HOME/.config/zsh"
echo "Installing feature 'dstockhammer/zsh' to $INSTALL_DIR"
if ! git clone --depth=1 https://github.com/dstockhammer/zsh.git $INSTALL_DIR; then
  echo "Failed to activate feature 'dstockhammer/zsh':"
  echo "Unable to clone https://github.com/dstockhammer/zsh.git"
  exit $exit_code
fi

ANTIDOTE_DIR="$_REMOTE_USER_HOME/.antidote"
if ! git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_DIR; then
  echo "Failed to activate feature 'dstockhammer/zsh':"
  echo "Unable to clone https://github.com/mattmc3/antidote.git"
  exit $exit_code
fi

mkdir -p $ZSH_VOLUME_DIR
chown -R $_REMOTE_USER:$_REMOTE_USER $ZSH_VOLUME_DIR $INSTALL_DIR $ANTIDOTE_DIR

if [ ! -z $ZSHHISTORY ]; then
  HISTFILE="$ZSHHISTORY"
else
  HISTFILE="$ZSH_VOLUME_DIR/.zsh_history"
fi

cat > $_REMOTE_USER_HOME/.zshenv \
<< EOF
export HISTFILE="$HISTFILE"
export ANTIDOTE_DIR="$ANTIDOTE_DIR"
export ZDOTDIR="$INSTALL_DIR"
[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
EOF

# Make sure to remove the existing .zshrc if it exists!
rm -rf $_REMOTE_USER_HOME/.zshrc

sudo chsh -s $(which zsh) $_REMOTE_USER
