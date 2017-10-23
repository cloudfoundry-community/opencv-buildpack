#!/bin/bash

set -e

: ${SRC_DIR:?required}
: ${OUTPUT_DIR:?required}
TMP_SRC_DIR=${TMP_DIR:-/tmp/src}
TMP_BUILD_DIR=${TMP_DIR:-/tmp/build}

mkdir -p $TMP_SRC_DIR
cd $TMP_SRC_DIR
rm -rf redis-*/

tar xfz $SRC_DIR/redis-*.tar.gz
cd redis-*/

make PREFIX=${TMP_BUILD_DIR} install

cd $TMP_BUILD_DIR
tar cfz ${OUTPUT_DIR}/redis.tgz .
