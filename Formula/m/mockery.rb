class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "472380b8d1b0838274e3e3f8f11008504840aa08ffe61ce3184804d29f111b29"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ffd0607ba8cc90b53782de55f91a711714fbc4e6f7631dbe83fba22c3aa1899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ffd0607ba8cc90b53782de55f91a711714fbc4e6f7631dbe83fba22c3aa1899"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ffd0607ba8cc90b53782de55f91a711714fbc4e6f7631dbe83fba22c3aa1899"
    sha256 cellar: :any_skip_relocation, sonoma:        "632dfec12664f5b60b9cfae077d1953a55e65b16662b425e522fa79b409e9d40"
    sha256 cellar: :any_skip_relocation, ventura:       "632dfec12664f5b60b9cfae077d1953a55e65b16662b425e522fa79b409e9d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fdbb953057fc8bf3a82a94740643996c080162537ce4e0d6b541cbddd769cf0"
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
