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
	if err := ss.InstallOpenCV(); err != nil {
		ss.Log.Error("Unable to install opencv: %s", err.Error())
		return err
	}

	return nil
}

func (ss *Supplier) InstallOpenCV() error {
	ss.Log.BeginStep("Installing opencv")

	opencv, err := ss.Manifest.DefaultVersion("opencv")
	if err != nil {
		return err
	}
	ss.Log.Info("Using opencv version %s", opencv.Version)

	if err := ss.Manifest.InstallDependency(opencv, ss.Stager.DepDir()); err != nil {
		return err
	}
	return nil
}
