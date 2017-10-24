#!/bin/bash

set -e

# either set $VERSION, or pass in from ${VERSION_FROM} file (e.g. concourse resource)
VERSION=${VERSION:-$(cat ${VERSION_FROM})}

: ${SRC_DIR:?required}
: ${OUTPUT_DIR:?required}
TMP_SRC_DIR=${TMP_DIR:-tmp/src}
TMP_BUILD_DIR=${TMP_DIR:-tmp/build}

SRC_ZIP=$PWD/$(ls $SRC_DIR/*.zip)

SRC_DIR=$PWD/${SRC_DIR}
OUTPUT_DIR=$PWD/${OUTPUT_DIR}
TMP_SRC_DIR=$PWD/${TMP_SRC_DIR}
TMP_BUILD_DIR=$PWD/${TMP_BUILD_DIR}

if [[ "${SKIP_INSTALL_LINUX_PKG:-X}" == "X" ]]; then
  apt-get update
  apt-get install -y build-essential cmake \
      git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev \
      python3-dev python3-numpy \
      libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev

  wget -q -O - https://raw.githubusercontent.com/starkandwayne/homebrew-cf/master/public.key | apt-key add -
  echo "deb http://apt.starkandwayne.com stable main" | tee /etc/apt/sources.list.d/starkandwayne.list
  apt-get update
  apt-get install -y spruce
fi

mkdir -p $TMP_SRC_DIR
cd $TMP_SRC_DIR
rm -rf opencv-*/

unzip $SRC_ZIP
cd opencv-*/
mkdir release
cd release
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=${TMP_BUILD_DIR} ..
make
make install

mkdir -p $OUTPUT_DIR/blobs
mkdir -p $OUTPUT_DIR/manifest

cd $TMP_BUILD_DIR
tar cfz $OUTPUT_DIR/opencv-compiled-${VERSION}.tgz .
cd -
