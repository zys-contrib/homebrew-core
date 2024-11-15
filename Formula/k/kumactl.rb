class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.9.1.tar.gz"
  sha256 "16af959cb80b4a81492322db2a8aab0e779de0567cb83b480c89fe9a6e07cb9e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "726483ebec55231cb0366621452d90ee668c9861f50a0139320698a9d9616b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "726483ebec55231cb0366621452d90ee668c9861f50a0139320698a9d9616b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "726483ebec55231cb0366621452d90ee668c9861f50a0139320698a9d9616b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7c1c6bc51c4133e3c6af9c97facba3c4d393d557061a3888387c5c405afcd28"
    sha256 cellar: :any_skip_relocation, ventura:       "a7c1c6bc51c4133e3c6af9c97facba3c4d393d557061a3888387c5c405afcd28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73aa97bcbe455e1a84a1f3c3e0f5a5039b402b95567e6e403aa30843f1d024e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
