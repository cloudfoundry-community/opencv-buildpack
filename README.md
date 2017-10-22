# Redis buildpack for Cloud Foundry

Cloud Foundry applications can blend multiple buildpacks together. If your application would like the `redis-cli` or even the `redis-server` and its other files, then this buildpack is for you.

```
cf v3-push sample-app-with-redis -p fixtures/sample \
  -b https://github.com/cloudfoundry-community/redis-buildpack \
  -b ruby_buildpack
cf logs sample-app-with-redis --recent
```

I also built this buildpack as an experiment in creating a buildpack that owned and operated its own pre-compiled blobs that will be downloaded when you use the buildpack. 
