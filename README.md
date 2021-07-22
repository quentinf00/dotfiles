## My config files

**Rationale**: I have been developping using Pycharm IDE for a few years, and I am looking to try something else.

**My most used features on my ide**:
- Directory switching:
	- go to def
	- global search
	- fuzy path finder
- Dev helpers:
	- code hints
	- instant documentation
	- autocomplete
- Python runtime integration:
	- REPL
	- testing
	- debugging (used it less recently)
- Remote sync:
	- remote REPL
	- upload/download files

**Main pain points**
- Very heavy: I aprehend each time I need to open a project
- Proprietary: Ok as long as I am a student but what next
- Convoluted maybe, I feel that I am dependent on the IDE because I can't do my development directly on the remote machines
- The workflow can still be a bit heavy while doing datascience because the logs, data artefacts are on the remote machines

**My idealized workflow using vim**:
- I log on the desired machine  
- I resume/start my "dev setup" (tmux vim)
- I can edit and run my project in situ 

### Objective
In order to get used to this workflow I need to be able to port my config to the different machines and therefore I am following best practises.

### The tools
- Vim edit-compile-edit
- Tmux session management + terminal
- conda project/python dependencies

### First step: improve vim-tmux compat
- pane switching :check:
- clipboard sharing :check:
- tmux copy-mode :check:

### Requirements
- setup without root privilege:
	- stow without root
```
apt download stow
mkdir local_stow
dpkg -x stow.... local_stow
PERL5LIB=..../perl5 local_stow/..../bin/stow
```
- clone repo
- install:
	- [install miniconda](https://docs.conda.io/en/latest/miniconda.html)
	- install base deps: 
```
conda env update -f dot_files/conda/base_requirements
```
- stow everything:
```
stow git tmux fish vim
```


#### Install steps
```bash
sequence:
micromamba
neovim
stow

repo
```bash
wget https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage
chmod u+x nvim.appimage

wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda

wget https://raw.githubusercontent.com/quentinf00/dotfiles/conda/base_environment.yaml -O conda_ide.yaml
eval "$($HOME/miniconda/condabin/conda shell.bash hook)"
conda install -y mamba -c conda-forge
mamba env update -f conda_ide.yaml


wget https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz
tar -xvf stow-latest.tar.gz
./configure
cd

git clone https://github.com/quentinf00/dotfiles.git
cd dotfiles
git submodule update --init --recursive
stow zsh tmux vim git nvim sh

```

#### Opt
install delta from [here](https://github.com/dandavison/delta#installation)


### Possible next steps:
- switch to neovim (lsp, neorg...)
- switch to zsh (nested conda env)
- add ansible support to provision everything
	- micromamba
	- create conda env
	- stow
	- nvim
	- delta
	- oh my zsh

- Jupyter workflow without notebooks:
	- create ipython console
	- when wanting to display something:
		- start qt console with `jupyter qtconsole  --existing ... --JupyterWidget.include_other_output=True`
