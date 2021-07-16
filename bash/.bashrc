#!/bin/bash
eval $(miniconda/condabin/conda shell.bash hook)
[[ -z "${TMUX}" ]] && SHELL=$(which zsh) tmux -2 new -As -t home

