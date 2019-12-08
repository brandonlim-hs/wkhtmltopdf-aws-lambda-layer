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

# Invoke lambda function with wkhtmltopdf layer
invoke_lambda_function() {
    while [[ "$#" -gt 0 ]]; do
        case $1 in
        -c | --code)
            local CODE_DIR="$2"
            shift
            ;;
        -h | --handler)
            local HANDLER="$2"
            shift
            ;;
        -r | --runtime)
            local RUNTIME="$2"
            shift
            ;;
        *)
            echo "Unknown parameter: $1" >&2
            return 1
            ;;
        esac
        shift
    done

    printf "%s\n" "Runtime: $RUNTIME"
    docker run --rm \
        -v "$CODE_DIR":/var/task:ro,delegated \
        -v "$LAYER_DIR":/opt:ro,delegated \
        lambci/lambda:$RUNTIME \
        $HANDLER
    if [ $? -ne 0 ]; then ERRORS+=1; fi
    printf "\n"
}

# Test layer on:
#   operating system: Amazon Linux, runtime: Java 8
#   operating system: Amazon Linux 2, runtime: Java 11
JAVA_RUNTIMES="java8 java11"
JAVA_DIR="$PWD/tests/java"

# Package Java file. See: https://docs.aws.amazon.com/lambda/latest/dg/create-deployment-pkg-zip-java.html
rm -rf "$JAVA_DIR/build" && docker run --rm -v "$JAVA_DIR":/app -w /app gradle:6.0 gradle build -q

for runtime in $JAVA_RUNTIMES; do
    invoke_lambda_function \
        --code "$JAVA_DIR/build/package" \
        --handler "example.Example::handleRequest" \
        --runtime $runtime
done

# Test layer on:
#   operating system: Amazon Linux, runtime: Node.js 8.10
#   operating system: Amazon Linux 2, runtime: Node.js 10
#   operating system: Amazon Linux 2, runtime: Node.js 12
NODEJS_RUNTIMES="nodejs8.10 nodejs10.x nodejs12.x"

for runtime in $NODEJS_RUNTIMES; do
    invoke_lambda_function \
        --code "$PWD/tests/nodejs" \
        --handler "index.handler" \
        --runtime $runtime
done

# Test layer on:
#   operating system: Amazon Linux, runtime: Python 3.6
#   operating system: Amazon Linux, runtime: Python 3.7
#   operating system: Amazon Linux 2, runtime: Python 3.8
PYTHON_RUNTIMES="python3.6 python3.7 python3.8"

for runtime in $PYTHON_RUNTIMES; do
    invoke_lambda_function \
        --code "$PWD/tests/python" \
        --handler "lambda_function.lambda_handler" \
        --runtime $runtime
done

rm -rf $LAYER_DIR

if [ $ERRORS -gt 0 ]; then
    printf "\e[31m%s\n\e[0m" "Errors: $ERRORS"
    exit 1
else
    printf "\e[32m%s\n\e[0m" "OK"
    exit 0
fi
