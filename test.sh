#!/bin/bash

declare -i ERRORS
ERRORS=0
LAYER_DIR="$PWD/layer"
LAYER_ZIP="layer.zip"

if [ ! -s $LAYER_ZIP ]; then
    printf "\e[31m%s\n\e[0m" "cannot find or open $LAYER_ZIP"
    exit 1
fi

rm -rf $LAYER_DIR && unzip $LAYER_ZIP -d $LAYER_DIR 1>/dev/null

# Test layer on:
#   operating system: Amazon Linux, runtime: Java 8
#   operating system: Amazon Linux 2, runtime: Java 11
JAVA_RUNTIMES="java8 java11"
JAVA_DIR="$PWD/tests/java"

# Package Java file. See: https://docs.aws.amazon.com/lambda/latest/dg/create-deployment-pkg-zip-java.html
rm -rf "$JAVA_DIR/build" && docker run --rm -v "$JAVA_DIR":/app -w /app gradle:6.0 gradle build -q

for runtime in $JAVA_RUNTIMES; do
    printf "%s\n" "Runtime: $runtime"
    docker run --rm \
        -v "$JAVA_DIR/build/package":/var/task:ro,delegated \
        -v "$LAYER_DIR":/opt:ro,delegated \
        lambci/lambda:$runtime \
        example.Example::handleRequest
    if [ $? -ne 0 ]; then ERRORS+=1; fi
    printf "\n"
done

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

# Test layer on:
#   operating system: Amazon Linux, runtime: Python 3.6
#   operating system: Amazon Linux, runtime: Python 3.7
#   operating system: Amazon Linux 2, runtime: Python 3.8
PYTHON_RUNTIMES="python3.6 python3.7 python3.8"

for runtime in $PYTHON_RUNTIMES; do
    printf "%s\n" "Runtime: $runtime"
    docker run --rm \
        -v "$PWD/tests/python":/var/task:ro,delegated \
        -v "$LAYER_DIR":/opt:ro,delegated \
        lambci/lambda:$runtime \
        lambda_function.lambda_handler
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
