!#/bin/bash
export PATH="$HOME/.pixi/bin:$PATH"

function is_exe() {
    which "$@" &> /dev/null
}


echo "######"
echo "###### Install 1 \t\t: Installing and activating pixi"
echo "######"
if is_exe pixi; then
	echo "Pixi already installed"
else
	curl -fsSL https://pixi.sh/install.sh | bash
fi


echo "######"
echo "###### Install 2 \t\t: Installing chezmoi"
echo "######"

if is_exe chezmoi; then
	echo "Chezmoi already installed"
else
	pixi global install chezmoi
	chezmoi init quentinf00 
fi
chezmoi apply 


echo "######"
echo "###### Pixi install all"
echo "######"
pixi global sync


