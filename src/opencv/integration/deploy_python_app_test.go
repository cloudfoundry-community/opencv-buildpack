package integration_test

import (
	"path/filepath"

	"github.com/cloudfoundry/libbuildpack/cutlass"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("deploy a python app", func() {
	var app *cutlass.App
	AfterEach(func() {
		if app != nil {
			app.Destroy()
		}
		app = nil
	})

	BeforeEach(func() {
		app = cutlass.New(filepath.Join(bpDir, "fixtures", "py-sample"))
		app.Buildpacks = []string{"opencv_buildpack", "python_buildpack"}
		app.SetEnv("BP_DEBUG", "1")
	})

	It("succeeds", func() {
		PushAppAndConfirm(app)

		Expect(app.Stdout.String()).To(ContainSubstring("Installing opencv"))
		Expect(app.GetBody("/")).To(ContainSubstring("3.3.0"))

		if cutlass.Cached {
			By("with a cached buildpack", func() {
				By("logs the files it downloads", func() {
					Expect(app.Stdout.String()).To(ContainSubstring("Copy [/"))
				})
			})
		} else {
			By("with a uncached buildpack", func() {
				By("logs the files it downloads", func() {
					Expect(app.Stdout.String()).To(ContainSubstring("Download [https://"))
				})
			})
		}
	})
})
