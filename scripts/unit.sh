#!/usr/bin/env bash
set -euo pipefail

buildpack=redis

export ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

if [ ! -f $ROOT/.bin/ginkgo ]; then
  (cd $ROOT/src/$buildpack/vendor/github.com/onsi/ginkgo/ginkgo/ && go install)
fi

cd $ROOT/src/$buildpack/
ginkgo -r -skipPackage=integration
