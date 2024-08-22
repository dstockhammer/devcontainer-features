#!/bin/sh
set -e

VERSION=${VERSION:-latest}
FAILONERROR=${FAILONERROR:-false}

if [ "$FAILONERROR" = "true" ]; then
  exit_code=1
else
  exit_code=0
fi

required_commands="kubectl helm curl tar"
for command in $required_commands; do
  if ! type "$command" > /dev/null 2>&1; then
    echo "Failed to activate feature 'dstockhammer/helmfile':"
    echo "Unable to find $command. Please make sure it is installed."
    exit $exit_code
  fi
done

architecture=""
case $(uname -m) in
  i386|i686)   architecture="386" ;;
  x86_64)      architecture="amd64" ;;
  armv7l)      architecture="386" ;; # Assuming armv7l is treated as 32-bit ARM
  aarch64)     architecture="arm64" ;;
esac

if [ -z "$architecture" ]; then
  architecture="arm64"
  echo "Unable to determine architecture from '$(uname -m)'. Falling back to '$architecture'."
fi

if [ "$VERSION" = "latest" ]; then
  download_url=$(curl -s https://api.github.com/repos/helmfile/helmfile/releases/latest \
    | grep "browser_download_url.*/helmfile_.*_linux_${architecture}.tar.gz" \
    | cut -d : -f 2,3 \
    | tr -d \")
else
  download_url="https://github.com/helmfile/helmfile/releases/download/v${VERSION#v}/helmfile_${VERSION#v}_linux_${architecture}.tar.gz"
fi

install_dir="/usr/local/share/helmfile"
mkdir -p "$install_dir"

if ! curl -sL $download_url | tar xz -C $install_dir; then
  echo "Failed to activate feature 'dstockhammer/helmfile':"
  echo "Unable download helmfile from $download_url"
  exit $exit_code
fi

ln -s $install_dir/helmfile /usr/local/bin
chmod +x /usr/local/bin/helmfile

echo "Installed feature 'dstockhammer/helmfile' to $install_dir"
