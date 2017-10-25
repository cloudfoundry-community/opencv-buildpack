#!/bin/bash

set -e

: ${NAME:?required}
: ${REPO_ROOT:?required}
: ${REPO_OUT:?required}
: ${BLOB_NAME:?required}
: ${BLOB:?required}
: ${DOWNLOAD_ROOT_URL:?required}
: ${GIT_EMAIL:?required}
: ${GIT_NAME:?required}

# either set $VERSION, or pass in from ${VERSION_FROM} file (e.g. concourse resource)
VERSION=${VERSION:-$(cat ${VERSION_FROM})}

TMP_DIR=${TMP_DIR:-/tmp}
BLOB=$(ls $BLOB)

cat > $TMP_DIR/dependencies.yml <<YAML
default_versions:
- name: ${BLOB_NAME}
  version: ${BLOB_NAME}
dependencies:
- ((merge on version))
- name:    ${BLOB_NAME}
  version: ${BLOB_NAME}
  uri:     "${DOWNLOAD_ROOT_URL}/blobs/${BLOB_NAME}/$(basename ${BLOB})"
  md5:     "$(md5sum ${BLOB} | awk '{print $1}')"
  cf_stacks: [cflinuxfs2]
YAML

git clone ${REPO_ROOT} ${REPO_OUT}
spruce merge ${REPO_ROOT}/manifest.yml $TMP_DIR/dependencies.yml > ${REPO_OUT}/manifest.yml

# GIT!
if [[ -z $(git config --global user.email) ]]; then
  git config --global user.email "${GIT_EMAIL}"
fi
if [[ -z $(git config --global user.name) ]]; then
  git config --global user.name "${GIT_NAME}"
fi

cat <<EOF >>${REPO_OUT}/ci/release_notes.md

## ${BLOB_NAME}
Bumped to v${VERSION}. Made the default.
EOF

# GIT!
if [[ -z $(git config --global user.email) ]]; then
  git config --global user.email "ci@starkandwayne.com"
fi
if [[ -z $(git config --global user.name) ]]; then
  git config --global user.name "CI Bot"
fi

cd ${REPO_OUT}
git merge --no-edit ${BRANCH}
git add -A
git status
git commit -m "Bumped ${BLOB_NAME} to v${VERSION}"
