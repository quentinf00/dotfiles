!#/bin/bash


    which "$@" &> /dev/null
}



echo "######"
echo "###### Install 1 \t\t: Installing and activating mise"
echo "######"
if is_exe mise; then
	echo "Mise already installed"
else:
	curl https://mise.run | sh
	eval "$(~/.local/bin/mise activate bash)"
fi

echo "######"
echo "###### Install 2 \t\t: Installing pixi"
echo "######"

if is_exe chezmoi; then
	echo "Chezmoi already installed"
else:
	mise use --env local chezmoi
	eval "$(~/.local/bin/mise activate bash)"
	chezmoi init quentinf00 -v
fi

chezmoi apply


echo "######"
echo "###### Install 3 \t\t: install everything mise"
echo "######"
mise install
eval "$(~/.local/bin/mise activate bash)"


echo "######"
echo "###### Install 4 \t\t: install everything pixi"
echo "######"
pixi install


