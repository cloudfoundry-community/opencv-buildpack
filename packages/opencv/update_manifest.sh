#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/../..

: ${NAME:?required}
: ${VERSION:?required}
: ${OUTPUT_DIR:?required}
TMP_DIR=${TMP_DIR:-/tmp}

cat > $TMP_DIR/dependencies.yml <<YAML
dependencies:
- name: ${NAME}
  version: ${VERSION}
  uri: http://${NAME}-buildpack.s3-website-us-east-1.amazonaws.com/blobs/${NAME}/${NAME}-compiled-${VERSION}.tgz
  md5: $(cat $OUTPUT_DIR/manifest/md5)
  cf_stacks: [cflinuxfs2]
YAML

spruce merge manifest.yml $TMP_DIR/dependencies.yml > $TMP_DIR/manifest.yml
cp $TMP_DIR/manifest.yml manifest.yml
