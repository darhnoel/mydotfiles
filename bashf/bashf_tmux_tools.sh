#!/bin/bash

##########################################################
# CREATED:  2021-02-09                                   #
# AUTHOR:   Suineg-Darhnoel                              #
# PROGRAM:  CREATE TMUX COMPLEX STARTUP WITH BASH        #
##########################################################

EASYT_NAME=""
EASYT_DEFAULT=1
EASYT_CMDS=(
    eztm_cmdlist
    eztm_new_session
    eztm_gridh
    eztm_gridv
    eztm_pythonh
)

alias tmuxls="tmux ls"

eztm_cmdlist(){
    echo "<< EASY TMUX LIST >>"
    for cmd in ${EASYT_CMDS[@]};do
        echo "[ $cmd  ]"
    done
}

eztm_attach(){
    tmux -a t $1
}

eztm_new_session(){
    if [[ -z $1 ]];then
        tmux
    else
        tmux new-session -s $1
    fi
}

eztm_gridh(){
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

eztm_gridv(){
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

eztm_pythonh(){
    tmux new-session \;\
    split-window -v -p 30\;\
    send-keys 'python3' C-m\;
}
