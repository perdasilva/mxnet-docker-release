#!/usr/bin/env bash

set -ex

# Variant parameter should be passed in
mxnet_variant=${1:?"Missing mxnet variant"}
python_cmd=${2:?"Missing python version (python or python3)"}

# Execute tests
if [[ $mxnet_variant == cu* ]]; then
    mnist_params="--gpu 0"
    test_conv_params="--gpu"
fi

if [[ $mxnet_variant == *mkl ]]; then
    ${python_cmd} tests/python/mkl/test_mkldnn.py
fi

${python_cmd} tests/python/train/test_conv.py ${test_conv_params}
${python_cmd} example/image-classification/train_mnist.py ${mnist_params}
