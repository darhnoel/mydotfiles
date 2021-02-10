# CUDA CONFIG FOR EXPERIMENTING WITH DARKNET
# CHECK IF THE SYSTEM HAS GPU

VGA_MSG=$(lspci -vnnn | perl -lne 'print if /^\d+\:.+(\[\S+\:\S+\])/' | grep VGA)

if [[ $VGA_MSG != "" ]]; then
    VISUAL_ROOT="/usr/lib"
    REAL_ROOT="/opt/cuda/9.0/lib64"

    # to run darknet
    export CPATH=/opt/cuda/9.0/include:$CPATH
    export LD_LIBRARY_PATH=/opt/cuda/9.0/lib64:$LD_LIBRARY_PATH
    export PATH=/opt/cuda/9.0/bin:$PATH

    # do symlink to make 'make' execute the Makefile
    # require root access
    LIBS4DARKNET=(
        "libcudart.so"
        "libcublas.so"
        "libcurand.so"
    )

    for _lib in ${LIBs4DARKNET[@]}
    do
        cucmd="sudo ln -s $REAL_ROOT/$_lib $VISUAL_ROOT/$_lib"
        if [[ -L $VISUAL_ROOT/$_lib && -f $VISUAL_ROOT/$_lib ]]
        then
            echo $cucmd
            command $cucmd
        fi
    done
fi
