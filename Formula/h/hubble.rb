class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.16.5.tar.gz"
  sha256 "7fbcbc321ef3dc0ed67a84ecfe0749898ea3a11b72a3f9b279ae6b272e38a819"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8205131fd611d0435a56677a4b8549c62babb9e2d1ba2e8b9591563e7decc3e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8205131fd611d0435a56677a4b8549c62babb9e2d1ba2e8b9591563e7decc3e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8205131fd611d0435a56677a4b8549c62babb9e2d1ba2e8b9591563e7decc3e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d7230a154033706bb487e87aee89274bd1b1083770384bf891dbbb330f5ad53"
    sha256 cellar: :any_skip_relocation, ventura:       "1d7230a154033706bb487e87aee89274bd1b1083770384bf891dbbb330f5ad53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf289270a56e83232f558249ffd76b6972629c3c1430f4b90fe3ba3db44a480"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end
