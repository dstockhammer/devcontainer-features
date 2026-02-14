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

install_dir="$_REMOTE_USER_HOME/.config/zsh"
echo "Installing feature 'dstockhammer/zsh' to $install_dir"
if ! git clone --depth=1 https://github.com/dstockhammer/zsh.git $install_dir; then
  echo "Failed to activate feature 'dstockhammer/zsh':"
  echo "Unable to clone https://github.com/dstockhammer/zsh.git"
  exit $exit_code
fi

antidote_dir="$_REMOTE_USER_HOME/.antidote"
if ! git clone --depth=1 https://github.com/mattmc3/antidote.git $antidote_dir; then
  echo "Failed to activate feature 'dstockhammer/zsh':"
  echo "Unable to clone https://github.com/mattmc3/antidote.git"
  exit $exit_code
fi

mkdir -p $ZSH_VOLUME_DIR
chown -R $_REMOTE_USER:$_REMOTE_USER $ZSH_VOLUME_DIR

if [ ! -z $ZSHHISTORY ]; then
  HISTFILE="$ZSHHISTORY"
else
  HISTFILE="$ZSH_VOLUME_DIR/.zsh_history"
fi

cat > $_REMOTE_USER_HOME/.zshenv \
<< EOF
export HISTFILE="$HISTFILE"
export ANTIDOTE_DIR="$antidote_dir"
export ZDOTDIR="$install_dir"
[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
EOF

sudo chsh -s $(which zsh) $_REMOTE_USER
