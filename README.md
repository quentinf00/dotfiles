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
	- fish
- install:
	- [install miniconda](https://docs.conda.io/en/latest/miniconda.html)
	- install base deps: 
