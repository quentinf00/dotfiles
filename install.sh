#!/bin/bash

NVIM_APP_IMAGE_URL="https://github.com/neovim/neovim/releases/download/v0.6.1/nvim.appimage"
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
	mamba env update -f conda_ide.yaml
	rm -f ~/.zshrc ~/.bashrc
	conda init && mv ~/.bashrc ~/.condainitrc
	conda init zsh && mv ~/.zshrc ~/.condainitzshrc
}


install_stow(){
	PERL_MM_USE_DEFAULT=1 cpan Stow
}

stow_everything(){
	git clone --recurse-submodules --shallow-submodules --depth 1 https://github.com/quentinf00/dotfiles.git
	cd dotfiles
	stow zsh tmux vim git nvim bash
}

reinstall_everything(){
        rm -rf $MINICONDA_PREFIX
        bash ~/miniconda.sh -b -p $MINICONDA_PREFIX
        eval "$($MINICONDA_PREFIX/condabin/conda shell.bash hook)"
        conda install -y mamba -c conda-forge
        mamba env update -f conda_ide.yaml
        rm -f ~/.zshrc ~/.bashrc
        conda init && mv ~/.bashrc ~/.condainitrc
        conda init zsh && mv ~/.zshrc ~/.condainitzshrc
        PERL_MM_USE_DEFAULT=1 cpan Stow
        cd dotfiles
        stow zsh tmux vim git nvim bash
}

run_everything(){
	set_up_nvim
	install_miniconda
	init_conda_env
	install_stow
	stow_everything
}

