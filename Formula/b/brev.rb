class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.310.tar.gz"
  sha256 "d7d8a58878c037372022f0c1d8fa58e15eb3d198498b521332d05def84cff351"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62d93163e5ca4ec4f149adf1715899cafaae3ec7bf9204818ed7829b84a13092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62d93163e5ca4ec4f149adf1715899cafaae3ec7bf9204818ed7829b84a13092"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62d93163e5ca4ec4f149adf1715899cafaae3ec7bf9204818ed7829b84a13092"
    sha256 cellar: :any_skip_relocation, sonoma:        "68130acae5a92481a3e9b89a4159702cd59c8b22d0f614429a5aea8277dbb25e"
    sha256 cellar: :any_skip_relocation, ventura:       "68130acae5a92481a3e9b89a4159702cd59c8b22d0f614429a5aea8277dbb25e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4cad3838c487f692d8fd0d79a48c32509c7e9663a704c36bedb3b752a6a7570"
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
