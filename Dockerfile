ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG PYTHON_CMD=python
ARG MXNET_PKG
RUN apt-get update && \
    apt-get install -y wget ${PYTHON_CMD}-dev gcc && \
    wget https://bootstrap.pypa.io/get-pip.py && \
    ${PYTHON_CMD} get-pip.py

RUN pip install ${MXNET_PKG}
