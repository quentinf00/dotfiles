sequence:
micromamba
neovim
stow

repo
```bash
git clone https://github.com/quentinf00/dotfiles.git
git submodule update --init --recursive

wget -qO- https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
bin/micromamba shell init -s bash -p ~/micromamba 
source .bashrc
micromamba activate
micromamba install mamba -c conda-forge
mamba env update -f dotfiles/conda/base_environment.yaml

wget https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz
tar -xvf stow-latest.tar.gz
./configure
cd

    
cd dotfiles
stow fish tmux vim git

wget https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage
chmod u+x nvim.appimage
```
