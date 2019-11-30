#!/bin/bash

declare -i ERRORS
ERRORS=0
LAYER_DIR="$PWD/layer"
LAYER_ZIP="layer.zip"

rm -rf $LAYER_DIR && unzip $LAYER_ZIP -d $LAYER_DIR 1>/dev/null

# Test layer on:
#   operating system: Amazon Linux, runtime: Node.js 8.10
#   operating system: Amazon Linux 2, runtime: Node.js 10
#   operating system: Amazon Linux 2, runtime: Node.js 12
NODEJS_RUNTIMES="nodejs8.10 nodejs10.x nodejs12.x"

for runtime in $NODEJS_RUNTIMES; do
    printf "%s\n" "Runtime: $runtime"
    docker run --rm \
        -v "$PWD/tests/nodejs":/var/task:ro,delegated \
        -v "$LAYER_DIR":/opt:ro,delegated \
        lambci/lambda:$runtime \
        index.handler
    if [ $? -ne 0 ]; then ERRORS+=1; fi
    printf "\n"
done

rm -rf $LAYER_DIR

if [ $ERRORS -gt 0 ]; then
    printf "\e[31m%s\n\e[0m" "Errors: $ERRORS"
    exit 1
else
    printf "\e[32m%s\n\e[0m" "OK"
    exit 0
fi
