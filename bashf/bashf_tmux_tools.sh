#!/bin/bash

##########################################################
# CREATED:  2021-02-09                                   #
# AUTHOR:   Suineg-Darhnoel                              #
# PROGRAM:  CREATE TMUX COMPLEX STARTUP WITH BASH        #
##########################################################

EASYT_NAME=""
EASYT_DEFAULT=1
EASYT_CMDS=(
    easy_tm_cmdlist
    easy_tm_new_session
    easy_tm_gridh
    easy_tm_gridv
    easy_tm_pythonh
    easy_tm_pythonv
)

alias tmuxls="tmux ls"

easy_tm_cmdlist(){
    echo "<< EASY TMUX LIST >>"
    for cmd in ${EASYT_CMDS[@]};do
        echo "[ $cmd  ]"
    done
}

easy_tm_attach(){
    tmux -a t $1
}

easy_tm_new_session(){
    if [[ -z $1 ]];then
        tmux
    else
        tmux new-session -s $1
    fi
}

easy_tm_gridh(){
    #    IMAGE
    # ------------
    # |          | 70%
    # |----------|
    # |          | 30%
    # ------------

    tmux new-session \;\
    split-window -v -p 30\;\
    send-keys 'ls' C-m\;\
    select-pane -t 1\;
}

easy_tm_gridv(){
    #    IMAGE
    # ------------
    # |   |      |
    # |25%| 75%  |
    # |   |      |
    # ------------
    tmux new-session \;\
    send-keys 'view .' C-m\;\
    split-window -h -p 80\;
}

easy_tm_pythonh(){
    tmux new-session \;\
    split-window -v -p 30\;\
    send-keys 'python3' C-m\;
}
