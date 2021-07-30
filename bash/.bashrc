#!/bin/bash

alias t=SHELL='$(which zsh) tmux new -As home'

if [ -f "$HOME/.condainitrc" ]; then
	source ~/.condainitrc
fi

if [  "`which tmux`" ] && [ "`which zsh`" ]  && [ "$TMUX" == "" ]; then
	t
fi
