##########################################################
# CREATED:  2021-02-09                                   #
# AUTHOR:   Suineg-Darhnoel                              #
# PROGRAM:  Unlock bitlocker hard drive                  #
##########################################################

BLK_DIR="/media/bitlocker"
MNT_DIR="/media/mount"
DRIVE_PATTERN="^(/dev/sd\w+[0-9])"
FOUND_DRIVES=""

export DISLOCKER_CHECKED=false

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
        (($DISLOCKER_CHECKED)) && echo "dislocker [exists]"
        DISLOCKER_CHECKED=true
    fi
}

create_mount_dir(){
    if [ ! -d $1 ];then
        echo "sudo mkdir $1"
        sudo mkdir "$1"
    fi

    if [ ! -d $2 ];then
        echo "sudo mkdir $2"
        sudo mkdir "$2"
    fi
}

detected_drives_details(){
    echo "[------------------------ DETECT USB DRIVES -------------------------]"
    sudo fdisk -l | grep -E $DRIVE_PATTERN
}

use_bitlocker_drive(){
    echo "[------------------------ USE BITLOCKER DRIVE -------------------------]"
    sudo dislocker -V "$1" -u -- "$2"
    sudo mount -o loop,rw,umask=0 "$2/dislocker-file" "$3"
}

select_drive(){
    # color
    local GREEN='\033[1;32m'
    local RED='\033[1;31m'
    local OFF='\033[m'

    # show available drives
    detected_drives_details

    # show drives' names
    FOUND_DRIVES=($(sudo fdisk -l | grep -oE $DRIVE_PATTERN 2>&1))

    # show number of drives found
    echo -e "${#FOUND_DRIVES[@]} [ ${GREEN}found${OFF} ]"

    for fd in ${FOUND_DRIVES[@]};do
        echo -e "[ ${GREEN}${fd}${OFF} ]"
    done

    printf "Insert the label: "
    read DRIVE_LABEL
    use_bitlocker_drive $DRIVE_LABEL $1 $2
}

bitlocker_unlock(){
    local ID=$1
    if [ -z "$ID" ];then
        echo "Usage: bitlocker_unlock <ID>"
        return
    fi

    args="${BLK_DIR}_${ID} ${MNT_DIR}_${ID}"
    check_dislocker
    create_mount_dir $args   # create mount directory
    select_drive $args
}

bitlocker_umount(){
    local ID=$1

    if [ -z "$ID" ];then
        echo "Usage: bitlocker_umount <ID>"
        return
    fi

    sudo umount -l "${MNT_DIR}_${ID}"
    sudo umount -l "${BLK_DIR}_${ID}"
}

##########################################################
#          (end) Unlock bitlocker hard drive             #
##########################################################
