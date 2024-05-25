#!/usr/bin/env bash

command_exist() {
  command -v "$1" >/dev/null 2>&1
}

install_nvm() {
  local NVM_DIR="$HOME/bin/nvm"
  mkdir -p "$NVM_DIR"
  local NVM_INSTALL="https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh"
  wget -qO- "$NVM_INSTALL" | NVM_DIR="$NVM_DIR" bash
}

install_odoo_tools() {
  local CONTROL="$PWD/debian/odoo"
  sed -n -e 's/^\s*//p' "$CONTROL" | xargs sudo apt-get install -y
}

install_common_tools() {
  local CONTROL="$PWD/debian/common"
  sed -n -e 's/^\s*//p' "$CONTROL" | xargs sudo apt-get install -y
}

install_aws_cli() {
  local ARCH=$(uname -m)
  local AWS_CLI="https://awscli.amazonaws.com/awscli-exe-linux-$ARCH.zip"
  wget "$AWS_CLI" -O awscliv2.zip
  unzip awscliv2.zip
  mkdir -p "$HOME/bin"
  ./aws/install --install-dir "$HOME/bin/aws-cli" --bin-dir "$HOME/bin" --update
  rm -rf aws awscliv2.zip
}

install_neovim() {
  local NEOVIM_VERSION="${1:-stable}"
  if [ $NEOVIM_VERSION != "stable" ]; then
    NEOVIM_VERSION="v$NEOVIM_VERSION"
  fi
  echo "Installing Neovim $NEOVIM_VERSION"
  local NVIM_APPIMAGE="https://github.com/neovim/neovim/releases/download/$NEOVIM_VERSION/nvim.appimage"
  wget "$NVIM_APPIMAGE"
  chmod +x nvim.appimage
  ./nvim.appimage --appimage-extract
  mv squashfs-root "$HOME/bin"
  ln -s "$HOME/bin/squashfs-root/usr/bin/nvim" "$HOME/bin/vi"
  ln -s "$HOME/bin/squashfs-root/usr/bin/nvim" "$HOME/bin/nvim"
  rm nvim.appimage
}

install_ripgrep() {
  local RIPGREP_VERSION="14.1.0"
  local RIPGREP_VERSION="${1:-$RIPGREP_VERSION}"
  echo "Installing Ripgrep $RIPGREP_VERSION"
  local ARCH=$(uname -m)
  local RIPGREP="https://github.com/BurntSushi/ripgrep/releases/download/$RIPGREP_VERSION/ripgrep-$RIPGREP_VERSION-$ARCH-unknown-linux-musl.tar.gz"
  local OUTPUT=$(basename "$RIPGREP")
  wget "$RIPGREP"
  tar -xvf "$OUTPUT"
  mv "$(basename "$OUTPUT" .tar.gz)/rg" "$HOME/bin"
  rm -rf "$(basename "$OUTPUT" .tar.gz)"
  rm "$OUTPUT"
}

install_fd() {
  local FD_VERSION="10.1.0"
  local FD_VERSION="${1:-$FD_VERSION}"
  echo "Installing Fd $FD_VERSION"
  local ARCH=$(uname -m)
  local FD="https://github.com/sharkdp/fd/releases/download/v$FD_VERSION/fd-v$FD_VERSION-$ARCH-unknown-linux-musl.tar.gz"
  local OUTPUT=$(basename "$FD")
  wget "$FD"
  tar -xvf "$OUTPUT"
  mv "$(basename "$OUTPUT" .tar.gz)/fd" "$HOME/bin"
  rm -rf "$(basename "$OUTPUT" .tar.gz)"
  rm "$OUTPUT"
}

install_fzf() {
  local FZF_VERSION="0.52.1"
  local FZF_VERSION="${1:-$FZF_VERSION}"
  echo "Installing Fzf $FZF_VERSION"
  local ARCHITECTURE=$(dpkg --print-architecture)
  local FZF="https://github.com/junegunn/fzf/releases/download/$FZF_VERSION/fzf-$FZF_VERSION-linux_$ARCHITECTURE.tar.gz"
  local OUTPUT=$(basename "$FZF")
  wget "$FZF"
  tar -xvf "$OUTPUT" -C "$HOME/bin"
  rm "$OUTPUT"
}

install_ohmyzsh() {
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_zsh_autosuggestions() {
  local ZSH_AUTOSUGGESTIONS="https://github.com/zsh-users/zsh-autosuggestions"
  git clone "$ZSH_AUTOSUGGESTIONS" "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
}

install_gh_cli() {
  local GH_CLI_VERSION="2.49.2"
  local GH_CLI_VERSION="${1:-$GH_CLI_VERSION}"
  echo "Installing Gh Cli $GH_CLI_VERSION"
  local ARCHITECTURE=$(dpkg --print-architecture)
  local GH_CLI="https://github.com/cli/cli/releases/download/v$GH_CLI_VERSION/gh_${GH_CLI_VERSION}_linux_$ARCHITECTURE.tar.gz"
  local OUTPUT=$(basename "$GH_CLI")
  wget "$GH_CLI"
  tar -xvf "$OUTPUT"
  mv "$(basename "$OUTPUT" .tar.gz)/bin/gh" "$HOME/bin"
  rm -rf "$(basename "$OUTPUT" .tar.gz)"
  rm "$OUTPUT"
}

install_go() {
  local GO_VERSION="1.22.3"
  local GO_VERSION="${1:-$GO_VERSION}"
  echo "Installing Go $GO_VERSION"
  local ARCHITECTURE=$(dpkg --print-architecture)
  local GO="https://go.dev/dl/go$GO_VERSION.linux-$ARCHITECTURE.tar.gz"
  local OUTPUT=$(basename "$GO")
  wget "$GO"
  tar -xzf "$OUTPUT" -C "$HOME/bin"
  rm "$OUTPUT"
}

install_hugo() {
  local HUGO_VERSION="0.126.1"
  local HUGO_VERSION="${1:-$HUGO_VERSION}"
  echo "Installing Hugo $HUGO_VERSION"
  local ARCHITECTURE=$(dpkg --print-architecture)
  local HUGO="https://github.com/gohugoio/hugo/releases/download/v$HUGO_VERSION/hugo_${HUGO_VERSION}_linux-$ARCHITECTURE.tar.gz"
  local OUTPUT=$(basename "$HUGO")
  wget "$HUGO"
  mkdir -p "$HOME/bin/hugo"
  tar -xvf "$OUTPUT" -C "$HOME/bin/hugo"
  rm "$OUTPUT"
}

install_ohmyposh() {
  wget -qO- https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin
}
