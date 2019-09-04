age="Usage: release.sh version"

mxnet_version=${1:?$usage}

export RELEASE_BUILD=true
export VERSION=${mxnet_version}

export RELEASE_DOCKERHUB_REPOSITORY="mxnet"

for mxnet_variant in cpu mkl cu80 cu80mkl cu90 cu90mkl cu100 cu100mkl cu101 cu101mkl; do
  for python_version in py2 py3; do
    ./python_docker.sh build ${mxnet_variant} ${python_version}
    ./python_docker.sh test ${mxnet_variant} ${python_version}
    ./python_docker.sh push ${mxnet_variant} ${python_version}
  done
done

