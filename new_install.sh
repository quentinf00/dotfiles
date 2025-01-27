!#/bin/bash
echo "######"
echo "###### Install 1 \t\t: Installing and activating mise"
echo "######"
curl https://mise.run | sh
eval "$(~/.local/bin/mise activate bash)"

echo "######"
echo "###### Install 2 \t\t: Installing pixi"
echo "######"
mise use --env local chezmoi
chezmoi init quentinf00


echo "######"
echo "###### Install 3 \t\t: install everything mise"
echo "######"
mise install


echo "######"
echo "###### Install 4 \t\t: install everything pixi"
echo "######"
pixi install


