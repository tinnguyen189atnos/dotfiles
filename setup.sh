#!/usr/bin/env bash

\. "$PWD/install.sh"
mkdir -p "$HOME/bin"

# Install NVM, Node.js
NVM_DIR="$HOME/bin/nvm"
if [ -d "$NVM_DIR" ]; then
  echo "Repository already exists in $NVM_DIR"
else
  install_nvm
fi
if ! command_exist "node"; then
  if ! command_exist "nvm"; then
	  \. "$NVM_DIR/nvm.sh"
  fi
  nvm install node
else
  echo "Node $(node --version) already installed"
fi

install_odoo_tools &>/dev/null
install_common_tools &>/dev/null

# Install AWS CLI
if ! command_exist "aws"; then
  install_aws_cli
else
  echo "AWS $(aws --version) already installed"
fi

# Install Neovim
if ! command_exist "nvim"; then
  install_neovim
else
  echo "Neovim $(nvim --version | head -n 1) already installed"
fi

# Install Ripgrep
if ! command_exist "rg"; then
  install_ripgrep
else
  echo "Ripgrep $(rg --version | head -n 1) already installed"
fi

# Install Fd
if ! command_exist "fd"; then
  install_fd
else
  echo "Fd $(fd --version) already installed"
fi

# Install Fzf
if ! command_exist "fzf"; then
  install_fzf
else
  echo "Fzf $(fzf --version) already installed"
fi

# Install Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh already installed"
else
  install_ohmyzsh
fi

# Install Zsh Autosuggestions
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  echo "Zsh Autosuggestions already installed"
else
  install_zsh_autosuggestions
fi

# Install Github CLI
if ! command_exist "gh"; then
  install_gh_cli
else
  echo "Github CLI $(gh --version) already installed"
fi

# Install Go
if ! command_exist "go"; then
  install_go
else
  echo "Go $(go version) already installed"
fi

# Install Hugo
if ! command_exist "hugo"; then
  install_hugo
else
  echo "Hugo $(hugo version) already installed"
fi
