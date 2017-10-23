#!/bin/bash

set -e

: ${VERSION:?required}
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

mkdir -p ${OUTPUT_DIR}/blobs
mkdir -p ${OUTPUT_DIR}/manifest

cd $TMP_BUILD_DIR
tar cfz ${OUTPUT_DIR}/blobs/redis-compiled-${VERSION}.tgz .

cd ${OUTPUT_DIR}
echo "${VERSION}" > manifest/version
echo "redis-compiled-${VERSION}.tgz" > manifest/filename
sha1sum blobs/redis-compiled-${VERSION}.tgz | awk '{print $1}' > manifest/sha1
md5 blobs/redis-compiled-${VERSION}.tgz | awk '{print $4}' > manifest/md5
