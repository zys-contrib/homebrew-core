class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.4.tar.gz"
  sha256 "2365f1b7a2738d61ff7a2ffdcd8b1ec30418c27662284a230a67a4e1744a4e6a"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78da30560caec2706d63f2924650923a8a5bfb76585a2c71041282be9a7c9f9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18a960202b7951b158c2b070208675fb3b2c1849c972feef036973d32d0015ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "860bf6ce703bbd510bb890036579c67ea5ed78eb8500c81dc6ee4bc25ebfcc00"
    sha256 cellar: :any_skip_relocation, sonoma:        "bff69d3c69141c4f70ecb7ea224e68a91217c080d8c6e7e185bc879a803cdf3d"
    sha256 cellar: :any_skip_relocation, ventura:       "d374f401c7fc2d150780fc123c43d93a08668f60a4850a498e9185e685fb6c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e477a03ccbb89996e2d0a06f62b0f0ac114f06ca4052b8d786dfa7cd07bbed"
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
