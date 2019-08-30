#!/usr/bin/env bash

set -xe

usage="Usage: python_images.sh <build|test|publish> MXNET-VARIANT <py2|py3>"

command=${1:?$usage}
mxnet_variant=${2:?$usage}
python_version=${3:?usage}

cd_utils='cd/utils'

case ${python_version} in
    py3)
        python_cmd="python3"
        ;;
    py2)
        python_cmd="python"
        ;;
    *)
        echo "Error: specify python version with either 'py2' or 'py3'"
        exit 1
        ;;
esac

docker_tags=($(./docker_tag.sh ${mxnet_variant}))
main_tag="${docker_tags[0]}_${python_version}"
base_image=$(./mxnet_base_image.sh ${mxnet_variant})
mxnet_pkg=$(./mxnet_package.sh ${mxnet_variant})
repository="python"
image_name="${repository}:${main_tag}"

if [ ! -z "${RELEASE_DOCKERHUB_REPOSITORY}" ]; then
    image_name="${RELEASE_DOCKERHUB_REPOSITORY}/${image_name}"
fi

# Builds runtime image
build() {
    docker build -t "${image_name}" --build-arg MXNET_PKG=${mxnet_pkg} --build-arg PYTHON_CMD=${python_cmd} --build-arg BASE_IMAGE="${base_image}" -f Dockerfile .
}

# Tests the runtime image by executing runtime_images/test_image.sh within the image
# Assumes image exists locally
test() {
    local runtime_param=""
    if [[ ${mxnet_variant} == cu* ]]; then
        runtime_param="--gpus all"
    fi
    local test_image_name="${image_name}_test"
    
    docker build -t "${test_image_name}" --build-arg USER_ID=`id -u` --build-arg GROUP_ID=`id -g` --build-arg BASE_IMAGE="${image_name}" -f Dockerfile.test .
    docker run ${runtime_param} -u `id -u`:`id -g` -v `pwd`:/mxnet "${test_image_name}" ${resources_path}/test_python_image.sh "${mxnet_variant}" "${python_cmd}"
}

# Pushes the runtime image to the repository
# Assumes image exists locally
push() {
    if [ -z "${RELEASE_DOCKERHUB_REPOSITORY}" ]; then
        echo "Cannot publish image without RELEASE_DOCKERHUB_REPOSITORY environment variable being set."
        exit 1
    fi

    # Push image
    docker push "${image_name}"

    # Iterate over remaining tags, if any
    for ((i=1;i<${#docker_tags[@]};i++)); do
        local docker_tag="${docker_tags[${i}]}"
        local latest_image_name="${RELEASE_DOCKERHUB_REPOSITORY}/${repository}:${docker_tag}"

        # latest and latest gpu should only be pushed for py3
        if [[ ${docker_tag} == "latest" || ${docker_tag} == "latest_gpu" ]]; then
            if [[ ${python_version} == "py2" ]]; then
                continue
            fi
        else
            latest_image_name="${latest_image_name}_${python_version}"
        fi

        docker tag "${image_name}" "${latest_image_name}"
        docker push "${latest_image_name}"
    done    
}

case ${command} in
    "build")
        build
        ;;

    "test")
        test
        ;;

    "push")
        push
        ;;

    *)
        echo $usage
        exit 1
esac