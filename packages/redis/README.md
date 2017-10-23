# Build redis within cflinuxfs2

Our buildpack users will need to download a pre-compiled version of Redis. This Dockerfile describes how to compile Redis and output it as a `tgz` file. Another part of the toolchain will upload the tgz to a public place, from which buildpack users will download it on demand.

```
VERSION=4.0.2
mkdir -p tmp/redis-src
mkdir -p tmp/redis-output
curl -o tmp/redis-src/redis-$VERSION.tar.gz http://download.redis.io/releases/redis-$VERSION.tar.gz
docker run -ti \
  -v $PWD:/buildpack \
  -v $PWD/tmp/redis-src:/redis-src \
  -v $PWD/tmp/redis-output:/redis-output \
  -e VERSION=${VERSION:?required} \
  -e SRC_DIR=/redis-src \
  -e OUTPUT_DIR=/redis-output \
  cloudfoundry/cflinuxfs2 \
  /buildpack/packages/redis/compile.sh
```

If you have access to the CF Community S3 account, you can then upload new compiled blobs:

```
aws --profile cfcommunity s3 sync tmp/redis-output/blobs s3://redis-buildpack/blobs/redis
```

Then update `manifest.yml` with the full path for the download file and the `md5` value:

```
cat tmp/redis-output/manifest/md5
```

This really should be automated in future.
