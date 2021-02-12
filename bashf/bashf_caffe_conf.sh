#!/bin/bash

#############################################
#                                           #
#           configuration for caffe         #
#                                           #
#############################################

############   NOTE    #######################
# 2021/02/12
# I build and install caffe in "~/workdir/caffe"
# Therefore, the path to `caffe` command is
# `~/workdir/caffe/tools/caffe`
##############################################

# use git clean -f to remove files created by cmake
# when build fails
# readlink -f <link-name> -> will produce full path
# to the original file

export PYTHONPATH="$HOME/workdir/caffe/python:$PYTHONPATH"
export CAFFE_TOOLS_PATH="~/workdir/caffe/build/tools"

declare -a caffe_bins=(
    caffe
    compute_image_mean
    convert_imageset
    extract_features
    upgrade_net_proto_binary
    upgrade_net_proto_text
    upgrade_solver_proto_text
)

for cbin in ${caffe_bins[@]};do
    exp="${CAFFE_TOOLS_PATH}/${cbin}"
    alias ${cbin}_exe=$exp
done
