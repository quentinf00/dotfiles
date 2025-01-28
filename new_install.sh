!#/bin/bash

function is_exe() {
    which "$@" &> /dev/null
}


echo "######"
echo "###### Install 1 \t\t: Installing and activating mise"
echo "######"
if is_exe mise; then
	echo "Mise already installed"
else
	curl https://mise.run | sh
	eval "$(~/.local/bin/mise activate bash)"
fi


echo "######"
echo "###### Install 2 \t\t: Installing chezmoi"
echo "######"

if is_exe chezmoi; then
	echo "Chezmoi already installed"
else
	mise use --env local chezmoi
	eval "$(~/.local/bin/mise activate bash)"
	chezmoi init -v quentinf00 
fi
chezmoi apply -v


echo "######"
echo "###### Install 3 \t\t: install everything mise"
echo "######"
MISE_VERBOSE=1 mise install
eval "$(~/.local/bin/mise activate bash)"

echo "######"
echo "###### Install 4 \t\t: install git"
echo "######"
if is_exe git; then
	echo "Git already installed"
else
	pixi global install git
fi


echo "######"
echo "###### Install 5 \t\t: install zsh"
echo "######"
if is_exe zsh; then
	echo "Zsh already installed"
else
	pixi global install zsh
fi

echo "######"
echo "###### Install 6 \t\t: install tmux"
echo "######"
if is_exe tmux; then
	echo "Tmux already installed"
else
	pixi global install tmux
fi



