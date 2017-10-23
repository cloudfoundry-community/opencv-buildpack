#!/bin/bash

set -e

: ${SRC_DIR:?required}
: ${OUTPUT_DIR:?required}
TMP_DIR=${TMP_DIR:-/tmp}

mkdir -p $TMP_DIR
cd $TMP_DIR
rm -rf redis-*/

tar xfz $SRC_DIR/redis-*.tar.gz
cd redis-*/

make PREFIX=${OUTPUT_DIR} install
