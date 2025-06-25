class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "02586a2dcd30de1ab48106224cfbba4306f7d16e9e552bb5202c57c24610e5c8"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "v3"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31e13ab8f668e28dcacb564c4ed837f78f8cf1c5ffa7b593ddb51016148df304"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31e13ab8f668e28dcacb564c4ed837f78f8cf1c5ffa7b593ddb51016148df304"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31e13ab8f668e28dcacb564c4ed837f78f8cf1c5ffa7b593ddb51016148df304"
    sha256 cellar: :any_skip_relocation, sonoma:        "14bc419a50659dbb608307dbe86aff9fe6b529d0189bdae04bb861e4baca1d89"
    sha256 cellar: :any_skip_relocation, ventura:       "14bc419a50659dbb608307dbe86aff9fe6b529d0189bdae04bb861e4baca1d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6478eb1a5220ec758350ffddb1f914118a77f7b043dc2e278337a3a2e7bdadf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v#{version.major}/internal/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    (testpath/".mockery.yaml").write <<~YAML
      packages:
        github.com/vektra/mockery/v2/pkg:
          interfaces:
            TypesPackage:
    YAML
    output = shell_output("#{bin}/mockery 2>&1", 1)
    assert_match "Starting mockery", output
    assert_match "version=v#{version}", output
  end
end
