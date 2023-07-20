#!/usr/bin/env bash
set -eu -o pipefail
IFS=$'\n\t'

# Helper functions
msg() {
    printf "\033[1m%b\033[0m\n" "$1" >&2
}

error() {
    msg "\33[31m[✘]\33[0m ${1}"
    exit 1
}

program_exists() {
    command -v "$1" &>/dev/null || error "$1 mast be installed to continue."
}

variable_set() {
    [[ -n "$(printenv "$1")" ]] || error "$1 environment variable must be set to continue."
}

# Setup
msg "Checking..."
variable_set HOME
program_exists "curl"
program_exists "git"
program_exists "vim"
install_dir="$HOME/.vim"
repo="https://github.com/monkoose/vim-setup"
minpac_repo="https://github.com/k-takata/minpac.git"
echo ""
msg "Creating required directories..."
mkdir -pv "$HOME/.cache/vim/undo"
mkdir -pv "$HOME/.cache/vim/fzf_history"
echo ""
msg "Cloning the repository..."
git clone "$repo" "$install_dir"
echo ""
msg "Fetching minpac..."
git clone --depth=1 "$minpac_repo" "$install_dir/pack/minpac/opt/minpac"
echo ""
echo "Done."
