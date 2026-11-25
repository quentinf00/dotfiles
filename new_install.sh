#!/bin/bash
set -eo pipefail
export PATH="$HOME/.local/bin:$HOME/.pixi/bin:$PATH"

function is_exe() {
    command -v "$1" &> /dev/null
}


echo "######"
echo "###### Step 1: Installing pixi"
echo "######"
if is_exe pixi; then
	echo "Pixi already installed"
else
	curl -fsSL https://pixi.sh/install.sh | bash
fi


echo "######"
echo "###### Step 2: Installing chezmoi (bootstrap)"
echo "######"
if is_exe chezmoi; then
	echo "Chezmoi already installed"
else
	pixi global install chezmoi
fi
if [[ ! -e "$(chezmoi source-path)/.git" ]]; then
	chezmoi init quentinf00
fi


echo "######"
echo "###### Step 3: Installing zsh (static binary)"
echo "######"
mkdir -p "$HOME/.local/bin"

if is_exe zsh; then
	echo "zsh already installed"
else
	curl -fsSL https://raw.githubusercontent.com/romkatv/zsh-bin/master/install | sh -s -- -d ~/.local
fi

echo "######"
echo "###### Step 4: Applying configuration files (places pixi-global.toml)"
echo "######"
chezmoi apply


echo "######"
echo "###### Step 5: Installing pixi global packages"
echo "######"
pixi global sync


