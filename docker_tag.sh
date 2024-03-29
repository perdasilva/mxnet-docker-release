#!/usr/bin/env bash

mxnet_variant=${1:?"Please specify the mxnet variant as the first parameter"}
is_release=${RELEASE_BUILD:-false}
version=${VERSION:-nightly}

# The docker tags will be in the form <version>_<hardware>(_mkl)
# Eg. nightly_cpu, 1.4.0_cpu_mkl, nightly_gpu_cu80_mkl, etc.

if [[ ${mxnet_variant} == "cpu" ]]; then
    tag_suffix="cpu"
elif [[ ${mxnet_variant} == "mkl" ]]; then
    tag_suffix="cpu_mkl"
elif [[ ${mxnet_variant} == cu* ]]; then
    tag_suffix="gpu_${mxnet_variant}"

    # *mkl => *_mkl
    if [[ $tag_suffix == *mkl ]]; then
        tag_suffix="${tag_suffix:0:${#tag_suffix}-3}_mkl"
    fi
else
    echo "Error: Unrecognized mxnet variant: '${mxnet_variant}'."
    exit 1
fi

echo "${version}_${tag_suffix}"

# Print out latest tags as well
if [[ ${is_release} == "true" ]]; then
    if [[ ${mxnet_variant} == "cpu" ]]; then
        echo "latest"
        echo "latest_cpu"
    elif [[ ${mxnet_variant} == "mkl" ]]; then
        echo "latest_cpu_mkl"
    elif [[ ${mxnet_variant} == "cu90" ]]; then
        echo "latest_gpu"
    elif [[ ${mxnet_variant} == "cu90mkl" ]]; then
        echo "latest_gpu_mkl"
    fi
fi