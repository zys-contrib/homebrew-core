class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "9a087a1fcc56e88a7de0dfc987e015407097de5ae97f84ab446ad0a85944bec7"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c28196584da9f02156c2059256c428d92b027b99adc4642e5c636073462a3df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c28196584da9f02156c2059256c428d92b027b99adc4642e5c636073462a3df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c28196584da9f02156c2059256c428d92b027b99adc4642e5c636073462a3df"
    sha256 cellar: :any_skip_relocation, sonoma:        "d40d48eff5e1e01fef4298ad5b65054ccf980f17a4d44a3b37ea924272ae3ead"
    sha256 cellar: :any_skip_relocation, ventura:       "d40d48eff5e1e01fef4298ad5b65054ccf980f17a4d44a3b37ea924272ae3ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2951994e79b2504bec08e7b4cd4d7cbbde87a80515d43ee49c5a4d83f53f64c9"
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
