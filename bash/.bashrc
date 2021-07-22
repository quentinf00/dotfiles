#!/bin/bash

alias t=SHELL='$(which zsh) tmux -2 new -As home'

if [ -f "~/.condainitrc" ]; then
	source ~/.condainitrc
fi

if [  "`which tmux`" ] && [ "`which zsh`" ]  && [ "$TMUX" == "" ]; then
	t
fi
