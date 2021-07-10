##########################################################
# CREATED:  2021-02-09                                   #
# AUTHOR:   Suineg-Darhnoel                              #
# PROGRAM:  Unlock bitlocker hard drive                  #
##########################################################

BLK_DIR="/media/bitlocker"
MNT_DIR="/media/mount"
DRIVE_PATTERN="^(/dev/sd\w+[0-9])"
FOUND_DRIVES=""
DRIVE_INFO=""

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

init_usbdrive(){
    echo "[--------------UNLOCK USB DRIVE -------------]"
    check_dislocker      # check if dislocker exists
}

detected_drives_details(){
    echo "[--------------DETECT USB DRIVE -------------]"
    sudo fdisk -l | grep -E $DRIVE_PATTERN
}

use_bitlocker_drive(){
    echo "[--------------USE BITLOCKER DRIVE-------------]"
    sudo dislocker -V "$1" -u -- "$2"
    sudo mount -o loop,rw,umask=0 "$2/dislocker-file" "$3"
}

select_drive(){
    echo "[--------------SELECT BITLOCKER DRIVE-------------]"
    FOUND_DRIVES=$(sudo fdisk -l | grep -oE $DRIVE_PATTERN 2>&1)

    echo "${#FOUND_DRIVES[@]} found"
    for fd in ${FOUND_DRIVES[@]};do
        echo "[ $fd ]"
    done

    printf "Insert the label: "
    read DRIVE_LABEL
    use_bitlocker_drive $DRIVE_LABEL $1 $2
}

ezunlock_bitlocker(){
    echo "[--------------EASY UNLOCK -------------]"
    local ID=$1
    args="${BLK_DIR}_${ID} ${MNT_DIR}_${ID}"
    init_usbdrive
    create_mount_dir $args   # create mount directory
    select_drive $args
}

ezumount_bitlocker(){
    local ID=$1
    sudo umount -l "${MNT_DIR}_${ID}"
    sudo umount -l "${BLK_DIR}_${ID}"
}

##########################################################
#          (end) Unlock bitlocker hard drive             #
##########################################################
