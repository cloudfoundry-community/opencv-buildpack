# Redis buildpack for Cloud Foundry

Cloud Foundry applications can blend multiple buildpacks together. If your application would like the `redis-cli` or even the `redis-server` and its other files, then this buildpack is for you.

If you want to learn how to make a "supply"-only buildpack for multi-buildpack support, then this is an example buildpack for you. Learn more from [Keaty Gross at CF Summit EU 2017](https://www.youtube.com/watch?v=41wEXS03U78).

```
cf v3-push sample-app-with-redis -p fixtures/sample \
  -b https://github.com/cloudfoundry-community/redis-buildpack \
  -b ruby_buildpack
```

NOTE: you may need to change `sample-app-with-redis` to something unique if you get an error about the default route already existing on your Cloud Foundry.

During staging, you will see Redis being installed:

```
Successfully created container
Downloading build artifacts cache...
Downloading app package...
Downloaded app package (826B)
-----> Download go 1.9
-----> Running go build supply
-----> Redis Buildpack version 0.1.0
-----> Installing redis
       Using redis version 4.0.2
-----> Installing redis 4.0.2
       Download [http://redis-buildpack.s3-website-us-east-1.amazonaws.com/blobs/redis/redis-compiled-4.0.2.tgz]
-----> Ruby Buildpack version 1.7.4
-----> Supplying Ruby
-----> Installing bundler 1.15.4
...
```

If you hit the app it will display the output of `redis-cli -v` to show that Redis is installed:

```
Redis: redis-cli 4.0.2
```

## Background

I also built this buildpack as an experiment in creating a buildpack that owned and operated its own pre-compiled blobs that will be downloaded when you use the buildpack.

## Building latest Redis

The [`packages/redis`](https://github.com/cloudfoundry-community/redis-buildpack/tree/master/packages/redis) folder contains the instructions for compiling + uploading a binary version of Redis.
