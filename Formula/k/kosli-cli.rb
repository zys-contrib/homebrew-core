class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.10.15.tar.gz"
  sha256 "a03dd42c6bd5ce0ab73e7c1431e3c2f1253119a7dfba4d0118acb055eb951c63"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13cd09e27be4583ae20d9d78274d037717569224ce68577f628cbb266d2b33b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13cd09e27be4583ae20d9d78274d037717569224ce68577f628cbb266d2b33b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13cd09e27be4583ae20d9d78274d037717569224ce68577f628cbb266d2b33b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "45a605501ea4812bb2ab62e0969c353f8992b0da6675d2e58dd3190c56f69411"
    sha256 cellar: :any_skip_relocation, ventura:        "45a605501ea4812bb2ab62e0969c353f8992b0da6675d2e58dd3190c56f69411"
    sha256 cellar: :any_skip_relocation, monterey:       "45a605501ea4812bb2ab62e0969c353f8992b0da6675d2e58dd3190c56f69411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6543187740d4b617bf24767cd5a88922e6bac2319b5071b2325e762c4db3677e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
