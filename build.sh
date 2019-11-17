#!/bin/bash

set -e

LAYER_DIR="/layer"
LAYER_ZIP="layer.zip"
TEMP_DIR="/tmp"

DOCKER_IMAGE="amazonlinux:latest"
CONTAINER=$(docker run -d -it $DOCKER_IMAGE)

ARCHITECTURE=$(docker exec -it $CONTAINER arch | tr -d '\r\n')
WKHTMLTOPDF_URL="https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox-0.12.5-1.centos7.$ARCHITECTURE.rpm"
WKHTMLTOPDF_BIN="$TEMP_DIR/wkhtmltopdf.rpm"

# Download wkhtmltopdf.rpm
docker exec -it $CONTAINER \
    /bin/bash -c \
    "yum install -y wget \
    && wget -O ${WKHTMLTOPDF_BIN} ${WKHTMLTOPDF_URL}"

# Download and extract dependencies
docker exec -it $CONTAINER yum install --downloadonly --downloaddir=$TEMP_DIR $WKHTMLTOPDF_BIN
docker exec -it $CONTAINER yum install -y rpmdevtools
docker exec -it $CONTAINER /bin/bash -c "cd $TEMP_DIR && rpmdev-extract *rpm"

# Copy wkhtmltopdf binary and dependency libraries to directory for packaging
docker exec -it $CONTAINER mkdir -p $LAYER_DIR/{bin,lib}
docker exec -it $CONTAINER /bin/bash -c "cp $TEMP_DIR/wkhtml*/usr/local/bin/* $LAYER_DIR/bin"
docker exec -it $CONTAINER /bin/bash -c "cp $TEMP_DIR/*/usr/lib64/* $LAYER_DIR/lib || :"
# Compress files to reduce packaging size
docker exec -it $CONTAINER /bin/bash -c "cd $LAYER_DIR && zip -r $LAYER_ZIP bin lib"

docker cp $CONTAINER:/$LAYER_DIR/$LAYER_ZIP $LAYER_ZIP

docker rm -f $CONTAINER
