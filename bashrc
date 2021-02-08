
# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
# the default theme is bobby
export BASH_IT_THEME='zork'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true
# Set to actual location of gitstatus directory if installed
#export SCM_GIT_GITSTATUS_DIR="$HOME/gitstatus"
# per default gitstatus uses 2 times as many threads as CPU cores, you can change this here if you must
#export GITSTATUS_NUM_THREADS=8

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
# source "$BASH_IT"/completion/available/tmux.completion.bash
# source "$BASH_IT/plugins/available/tmux.plugin.bash"

export EDITOR=vim
export VISUAL=vim
export TERM="xterm-256color" # to fix color tmux-vim

source "$BASH_IT"/bash_it.sh

##########################################################
#               Unlock bitlocker hard drive              #
##########################################################
BLK_DIR="/media/bitlocker"
MNT_DIR="/media/mount"
DRIVE_PATTERN="^(/dev/\w+[0-9])"
FOUND_DRIVES=""

install_dislocker(){
    sudo apt install dislocker
}

check_dislocker(){
    if ! command -v dislocker &> /dev/null
    then
        echo "dislocker [not exists]"
        echo "install dislocker now [y/n]"
        # read input from user
        read ans
        if [ $ans == 'y' ];then
            install_dislocker
        else
            echo "dislocker installation was dismissed"
            return 0
        fi
    else
        echo "dislocker [exists]"
    fi
}

create_mount_dir(){
    if [ ! -d $BLK_DIR ];then
        echo "sudo mkdir $BLK_DIR"
        sudo mkdir $BLK_DIR
    fi
    
    if [ ! -d $MNT_DIR ];then
        echo "sudo mkdir $MNT_DIR"
        sudo mkdir $MNT_DIR 
    fi
}

find_usbdrive(){
    sudo fdisk -l | tail
}

unlock_usbdrive(){
    echo "--------------UNLOCK USB DRIVE -------------"
    check_dislocker      # check if dislocker exists
    create_mount_dir     # create mount directory
    find_usbdrive        # confirm the location of the bitlocker drive
}

detected_drives_details(){
    echo "--------------DETECT USB DRIVE -------------"
    unlock_usbdrive | grep -E $DRIVE_PATTERN
}

use_bitlocker_drive(){
    echo "--------------USE BITLOCKER DRIVE-------------"
    sudo dislocker -V "$1" -u -- $BLK_DIR
    sudo mount -o loop,rw,umask=0 "$BLK_DIR/dislocker-file" $MNT_DIR
}

select_drive(){
    echo "--------------SELECT BITLOCKER DRIVE-------------"
    FOUND_DRIVES=$(unlock_usbdrive | grep -Eo $DRIVE_PATTERN 2>&1)

    echo "There are(is) ${#FOUND_DRIVES[@]} usb drive found"
    for fd in ${FOUND_DRIVES[@]};do
        echo "[ $fd ]"
    done

    printf "Insert the label: "
    read DRIVE_LABEL
    use_bitlocker_drive $DRIVE_LABEL
}

easy_unlock_bitlocker(){
    echo "--------------EASY UNLOCK -------------"
    unlock_usbdrive
    detected_drives_details
    select_drive
}

umount_usbdrive(){
    sudo umount $MNT_DIR
    sudo umount $BLK_DIR
}

##########################################################
#          (end) Unlock bitlocker hard drive             #
##########################################################


if [ -f ~/.bash_alias ];then
    . ~/.bash_alias
fi

if [ -f ~/.caffe_config ];then
    . ~/.caffe_config
fi
