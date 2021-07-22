#!/bin/bash

alias t=SHELL='$(which zsh) tmux new -As home'

if [ -f ~/.condainitrc ]; then
	source ~/.condainitrc
fi

if [ -e "`which tmux`" -e "`which zsh`" -a "$PS1" != "" -a "$TMUX" == "" -a "${SSH_TTY:-x}" != x ]; then
	t
fi
