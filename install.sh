#!/bin/bash

NVIM_APP_IMAGE_URL="https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage"
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh"
MINICONDA_PREFIX="$HOME/miniconda"
STOW_PKG="stow-2.3.1"
STOW_URL="https://ftp.gnu.org/gnu/stow/$STOW_PKG.tar.gz"


set_up_nvim(){
	wget $NVIM_APP_IMAGE_URL -O ~/nvim.appimage
	chmod u+x ~/nvim.appimage
}

install_miniconda(){
	echo "installing miniconda"
	wget $MINICONDA_URL -O ~/miniconda.sh
	bash ~/miniconda.sh -b -p $MINICONDA_PREFIX
}


init_conda_env(){
	wget https://raw.githubusercontent.com/quentinf00/dotfiles/main/conda/base_environment.yaml -O conda_ide.yaml
	eval "$($MINICONDA_PREFIX/condabin/conda shell.bash hook)"
	conda install -y mamba -c conda-forge
	mamba env update -f conda_ide.yaml -y
	rm -f ~/.zshrc ~/.bashrc
	conda init && mv ~/.bashrc ~/.condainitrc
	conda init zsh && mv ~/.zshrc ~/.condainitzshrc
}


install_stow(){
	wget $STOW_URL
	tar -xvf $STOW_PKG.tar.gz
	cd $STOW_PKG
	./configure
	make install
	alias stow="PERL5LIB=$(pwd)/lib $(pwd)/bin/stow"
	cd
}

stow_everything(){
	git clone --recurse-submodules --shallow-submodules --depth 1 https://github.com/quentinf00/dotfiles.git
	cd dotfiles
	stow zsh tmux vim git nvim bash
}
