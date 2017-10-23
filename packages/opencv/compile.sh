#!/bin/bash

set -e

: ${VERSION:?required}
: ${SRC_DIR:?required}
: ${OUTPUT_DIR:?required}
TMP_SRC_DIR=${TMP_DIR:-/tmp/src}
TMP_BUILD_DIR=${TMP_DIR:-/tmp/build}

mkdir -p $TMP_SRC_DIR
cd $TMP_SRC_DIR
rm -rf opencv-*/

unzip $SRC_DIR/opencv-*.zip
cd opencv-*/
mkdir release
cd release
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=${TMP_BUILD_DIR} ..
make
make install

mkdir -p ${OUTPUT_DIR}/blobs
mkdir -p ${OUTPUT_DIR}/manifest

cd $TMP_BUILD_DIR
tar cfz ${OUTPUT_DIR}/blobs/opencv-compiled-${VERSION}.tgz .

cd ${OUTPUT_DIR}
echo "${VERSION}" > manifest/version
echo "opencv-compiled-${VERSION}.tgz" > manifest/filename
sha1sum blobs/opencv-compiled-${VERSION}.tgz | awk '{print $1}' > manifest/sha1
md5sum blobs/opencv-compiled-${VERSION}.tgz | awk '{print $4}' > manifest/md5
