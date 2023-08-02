#!/bin/bash

set -e

display_help() {
    echo "Usage: $0 BUILD_TYPE CRATE_PATH"
    echo "Valid options for BUILD_TYPE:"
    echo "  stable-wasm32-wasi-with-threads"
    echo "  stable-wasm32-wasi-preview1-threads"
    echo "  nightly-wasm32-wasi-preview1-threads"
}

if [ $# -ne 2 ]; then
    echo "Error: Invalid number of arguments."
    display_help
    exit 1
fi

BUILD_TYPE=$1
CRATE_PATH=$(readlink -f $2)

case "$BUILD_TYPE" in
"stable-wasm32-wasi-with-threads" | "stable-wasm32-wasi-preview1-threads" | "nightly-wasm32-wasi-preview1-threads")
    echo "Use: $BUILD_TYPE"
    ;;
*)
    echo "Error: Invalid argument: $BUILD_TYPE"
    display_help
    exit 1
    ;;
esac

RUST_REPO_URL=${RUST_REPO_URL:-"https://github.com/rust-lang/rust.git"}
RUST_REPO_BRANCH=${RUST_REPO_BRANCH:-"stable"}
DOCKER_FILE=Dockerfile.$BUILD_TYPE
DOCKER_TAG=loganek/rust-$BUILD_TYPE

case "$BUILD_TYPE" in
"stable-wasm32-wasi-with-threads")
    ;;
"stable-wasm32-wasi-preview1-threads")
    ;;
"nightly-wasm32-wasi-preview1-threads")
    RUST_REPO_BRANCH=master
    ;;
esac

docker build \
    -t $DOCKER_TAG-base:latest \
    -f Dockerfile.base \
    --build-arg RUST_REPO_BRANCH=$RUST_REPO_BRANCH \
    patches
docker build -t $DOCKER_TAG:latest -f $DOCKER_FILE patches

docker run -v $CRATE_PATH:/app -it $DOCKER_TAG
