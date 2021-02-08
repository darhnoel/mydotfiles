##########################################################
# CREATED:  2021-02-09                                   #
# AUTHOR:   Suineg-Darhnoel                              #
# PROGRAM:  Unlock bitlocker hard drive                  #
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

easy_unmount_bitlocker(){
    sudo umount $MNT_DIR
    sudo umount $BLK_DIR
}

##########################################################
#          (end) Unlock bitlocker hard drive             #
##########################################################
