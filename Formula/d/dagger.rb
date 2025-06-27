class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.18.12.tar.gz"
  sha256 "3c4a3fddc05b4f2109110a1515d3f6aa0909e5d28a9c3edee9010d0c788e8d16"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a3533b30d39ed2ea6ccec425966852b78a00206e2400656d5c02cd02742d90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43a3533b30d39ed2ea6ccec425966852b78a00206e2400656d5c02cd02742d90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43a3533b30d39ed2ea6ccec425966852b78a00206e2400656d5c02cd02742d90"
    sha256 cellar: :any_skip_relocation, sonoma:        "756907a46de1226598a041a9ff0b9a3dd45b766d192c87d519bea14a6a475b39"
    sha256 cellar: :any_skip_relocation, ventura:       "756907a46de1226598a041a9ff0b9a3dd45b766d192c87d519bea14a6a475b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ee8a717043d2e5b2e9671b99bce8d7b4e7f69ab1671cb6c6aa0f07cb0d0b3ed"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
