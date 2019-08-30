#!/usr/bin/env bash

mxnet_variant=${1:?"Please specify the mxnet variant as the first parameter"}

case ${mxnet_variant} in 
    cu80*)
    echo "nvidia/cuda:8.0-cudnn7-runtime-ubuntu16.04"
    ;;
    cu90*)
    echo "nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04"
    ;;
    cu91*)
    echo "nvidia/cuda:9.1-cudnn7-runtime-ubuntu16.04"
    ;;
    cu92*)
    echo "nvidia/cuda:9.2-cudnn7-runtime-ubuntu16.04"
    ;;
    cu100*)
    echo "nvidia/cuda:10.0-cudnn7-runtime-ubuntu16.04"
    ;;
    cu101*)
    echo "nvidia/cuda:10.1-cudnn7-runtime-ubuntu16.04"
    ;;
    cpu)
    echo "ubuntu:16.04"
    ;;
    mkl)
    echo "ubuntu:16.04"
    ;;
    *)
    echo "Error: Unrecognized mxnet-variant: '${mxnet_variant}'"
    exit 1
    ;;
esac