#!/usr/bin/env bash
set -ex

buildpack=redis

export ROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
BINDIR=$ROOTDIR/bin

export GOPATH=$ROOTDIR
export GOOS=linux

go build -ldflags="-s -w" -o $BINDIR/supply $buildpack/supply/cli
