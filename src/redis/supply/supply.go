package supply

import "github.com/cloudfoundry/libbuildpack"

type Manifest interface {
	DefaultVersion(string) (libbuildpack.Dependency, error)
	InstallDependency(libbuildpack.Dependency, string) error
}

type Stager interface {
	AddBinDependencyLink(string, string) error
	DepDir() string
}

type Supplier struct {
	Stager   Stager
	Manifest Manifest
	Log      *libbuildpack.Logger
}

func Run(ss *Supplier) error {
	if err := ss.InstallRedis(); err != nil {
		ss.Log.Error("Unable to install redis: %s", err.Error())
		return err
	}

	return nil
}

func (ss *Supplier) InstallRedis() error {
	ss.Log.BeginStep("Installing redis")

	redis, err := ss.Manifest.DefaultVersion("redis")
	if err != nil {
		return err
	}
	ss.Log.Info("Using redis version %s", redis.Version)

	if err := ss.Manifest.InstallDependency(redis, ss.Stager.DepDir()); err != nil {
		return err
	}
	return nil
	// return ss.Stager.AddBinDependencyLink(filepath.Join(ss.Stager.DepDir(), "redis", "bin", "redis-cli"), "redis-cli")
}
