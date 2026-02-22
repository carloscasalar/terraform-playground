#!/usr/bin/env bash
set -euo pipefail

curl -fsSL https://starship.rs/install.sh | sh -s -- --yes --force

BASH_INIT='eval "$(starship init bash)"'
ZSH_INIT='eval "$(starship init zsh)"'

touch ~/.bashrc ~/.zshrc

grep -qxF "$BASH_INIT" ~/.bashrc || echo "$BASH_INIT" >> ~/.bashrc
grep -qxF "$ZSH_INIT" ~/.zshrc || echo "$ZSH_INIT" >> ~/.zshrc
