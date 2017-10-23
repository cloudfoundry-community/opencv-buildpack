#!/usr/bin/env bash
set -euo pipefail
set -x

buildpack=opencv

export ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd $ROOT
source .envrc

if [[ "${CF_API_URL:-X}" != "X" ]]; then
  echo "Targeting CF ${CF_API_URL}..."
  set +x
  : ${CF_USERNAME:?required}
  : ${CF_PASSWORD:?required}
  : ${CF_ORGANIZATION:?required}
  : ${CF_SPACE:?required}
  cf api ${CF_API_URL} --skip-ssl-validation
  cf auth "${CF_USERNAME}" "${CF_PASSWORD}"
  cf target -o "${CF_ORGANIZATION}" -s "${CF_SPACE:?required}"
  set -x
fi

if [ ! -f "$ROOT/.bin/ginkgo" ]; then
  (cd "$ROOT/src/$buildpack/vendor/github.com/onsi/ginkgo/ginkgo/" && go install)
fi
if [ ! -f "$ROOT/.bin/buildpack-packager" ]; then
  (cd "$ROOT/src/$buildpack/vendor/github.com/cloudfoundry/libbuildpack/packager/buildpack-packager" && go install)
fi

GINKGO_NODES=${GINKGO_NODES:-3}
GINKGO_ATTEMPTS=${GINKGO_ATTEMPTS:-2}

cd $ROOT/src/$buildpack/integration

ginkgo -r --flakeAttempts=$GINKGO_ATTEMPTS -nodes $GINKGO_NODES
