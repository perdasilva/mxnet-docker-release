#!/usr/bin/env bash

mxnet_variant=${1:?"Please specify the mxnet variant as the first parameter"}

if [[ ${mxnet_variant} == "cpu" ]]; then
    tag_suffix=""
elif [[ ${mxnet_variant} == "mkl" ]]; then
    tag_suffix="-mkl"
elif [[ ${mxnet_variant} == cu* ]]; then
    tag_suffix="-${mxnet_variant}"
else
    echo "Error: Unrecognized mxnet variant: '${mxnet_variant}'."
    exit 1
fi

echo "mxnet${tag_suffix}"