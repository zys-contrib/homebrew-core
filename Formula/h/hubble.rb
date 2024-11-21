class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.16.4.tar.gz"
  sha256 "6ba4d5d745a880b19cb365ed98486f31188ffb5ec1d6fdba78598503bf422239"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e97ef788a6a906c3502d595566fd41943a743a296464fd63cd4f46b6faf31d9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e97ef788a6a906c3502d595566fd41943a743a296464fd63cd4f46b6faf31d9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e97ef788a6a906c3502d595566fd41943a743a296464fd63cd4f46b6faf31d9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeb6607364cddb3acd4cc7b8c8eecd1c3ef94f88c4b407123fcecdfe2e9d6b89"
    sha256 cellar: :any_skip_relocation, ventura:       "eeb6607364cddb3acd4cc7b8c8eecd1c3ef94f88c4b407123fcecdfe2e9d6b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6f95a0512305f41c02f8c22b3920e72a3964b034fb80b4ca0390ebb82435e2b"
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
