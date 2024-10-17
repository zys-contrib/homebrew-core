class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://www.brev.dev/"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.295.tar.gz"
  sha256 "49b945ddc8821c129eea946bed4b17f4f3ea96b4036a4c8b515a39289078a26e"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d01ccbe20f8fcbefc99019a7bbd58a72e68fd35e3351b2451c3495622fd023a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d01ccbe20f8fcbefc99019a7bbd58a72e68fd35e3351b2451c3495622fd023a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d01ccbe20f8fcbefc99019a7bbd58a72e68fd35e3351b2451c3495622fd023a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c27346f1c1f9a78a903eed8699a9abed287427318715f9438e28c0d4af81450c"
    sha256 cellar: :any_skip_relocation, ventura:       "c27346f1c1f9a78a903eed8699a9abed287427318715f9438e28c0d4af81450c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c829311fbb77807250165ac962de94995caabe1ca6a0ff08ed3b5cccb60c0365"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
