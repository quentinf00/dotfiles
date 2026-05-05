#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.pixi/bin:$PATH"

function is_exe() {
    which "$@" &> /dev/null
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
	chezmoi init quentinf00
fi


echo "######"
echo "###### Step 3: Installing zsh (static binary) and tmux (AppImage)"
echo "######"
mkdir -p "$HOME/.local/bin"

if is_exe zsh; then
	echo "zsh already installed"
else
	curl -fsSL https://raw.githubusercontent.com/romkatv/zsh-bin/master/install | sh -s -- -d ~/.local
fi

if is_exe tmux; then
	echo "tmux already installed"
else
	TMUX_VERSION=$(curl -fsSL "https://api.github.com/repos/nelsonenzo/tmux-appimage/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)
	curl -fsSLo "$HOME/.local/bin/tmux" "https://github.com/nelsonenzo/tmux-appimage/releases/download/${TMUX_VERSION}/tmux.appimage"
	chmod +x "$HOME/.local/bin/tmux"
fi


echo "######"
echo "###### Step 4: Applying configuration files (places pixi-global.toml)"
echo "######"
chezmoi apply


echo "######"
echo "###### Step 5: Installing pixi global packages"
echo "######"
pixi global sync


