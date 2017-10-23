# Build redis within cflinuxfs2

Our buildpack users will need to download a pre-compiled version of Redis. This Dockerfile describes how to compile Redis and output it as a `tgz` file. Another part of the toolchain will upload the tgz to a public place, from which buildpack users will download it on demand.

```
mkdir -p tmp/redis-src
mkdir -p tmp/redis-output
curl -o tmp/redis-src/redis-4.0.2.tar.gz http://download.redis.io/releases/redis-4.0.2.tar.gz
docker run -ti \
  -v $PWD:/buildpack \
  -v $PWD/tmp/redis-src:/redis-src \
  -v $PWD/tmp/redis-output:/redis-output \
  -e SRC_DIR=/redis-src \
  -e OUTPUT_DIR=/redis-output \
  cloudfoundry/cflinuxfs2 \
  /buildpack/packages/redis/compile.sh
```
