class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "f26a51165d0deba7f07ade5b65fcab58dd1daf6c4edfd2fb4124bcf856da9ad3"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5ce6bbe1303bb8cf874e4fa54488be5a5db013a2db204315508e86c160431b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5ce6bbe1303bb8cf874e4fa54488be5a5db013a2db204315508e86c160431b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5ce6bbe1303bb8cf874e4fa54488be5a5db013a2db204315508e86c160431b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "77811c94b68139c8eb05ca3341b33ff88770ca7623c73a1ed2b4607698f0ad21"
    sha256 cellar: :any_skip_relocation, ventura:       "77811c94b68139c8eb05ca3341b33ff88770ca7623c73a1ed2b4607698f0ad21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25dc38e1e86b1231a2c5e4632046e47a10aa7bc43f19fc440aea73e1247976a9"
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
