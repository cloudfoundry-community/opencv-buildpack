# Build opencv within cflinuxfs2

Our buildpack users will need to download a pre-compiled version of opencv. This Dockerfile describes how to compile opencv and output it as a `tgz` file. Another part of the toolchain will upload the tgz to a public place, from which buildpack users will download it on demand.


```
VERSION=3.3.0
mkdir -p tmp/opencv-src
mkdir -p tmp/opencv-output
curl -o tmp/opencv-src/opencv-$VERSION.tar.gz http://download.opencv.io/releases/opencv-$VERSION.tar.gz
docker run -ti \
  -e VERSION=${VERSION:?required} \
  -v $PWD:/buildpack \
  -v $PWD/tmp/opencv-src:/opencv-src \
  -v $PWD/tmp/opencv-output:/opencv-output \
  -e SRC_DIR=/opencv-src \
  -e OUTPUT_DIR=/opencv-output \
  cloudfoundry/cflinuxfs2 \
  /buildpack/packages/opencv/compile.sh
```

Then upload new compiled blobs to your S3 account/bucket. In CI, this is performed with an `s3` resource.

```
bucket=opencv-buildpack
aws s3 sync tmp/opencv-output/blobs s3://$bucket/blobs/opencv
```

Then update `manifest.yml` with the full path for the download file and the `md5` value:

```
docker run -ti \
  -v $PWD:/buildpack \
  -v $PWD/tmp/opencv-output:/opencv-output \
  -e NAME=${NAME:?required} \
  -e VERSION=${VERSION:?required} \
  -e REGION=us-east-1 \
  -e OUTPUT_DIR=/opencv-output \
  cfcommunity/opencv-buildpack-pkg-builder \
  /buildpack/packages/$NAME/update_manifest.sh
```

This really should be automated in future.
