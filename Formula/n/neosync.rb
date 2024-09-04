class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.60.tar.gz"
  sha256 "270d4c2964be6e7385c7eb902fac481f0493d97ce55dcbb9f3b490e1a2d4e02f"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7d0c3b1f5b282a69ef4070fed73884f7a922374e7d7c41a00acdfb31903718e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e20ce5b8a47b8ad065cc65c6254962975da127bf4264f18e92c35ecc28c1527"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80e1b3da3682139aead066cd5b9b8a8c0e9516205ab40ef6dbc335ba2a5d9cb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "922b3f578667d3c6d6e705fb8d674d30b6902d604487110a066ac89c7d8b4926"
    sha256 cellar: :any_skip_relocation, ventura:        "eb58ecb609db880f92b9d2373c100030828b723bc181a27c16d4987e68ed34a4"
    sha256 cellar: :any_skip_relocation, monterey:       "958dff3d7fb75df86f27d08000a57d0bae777fc387d1817f5a95cf980a80e8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a27f71c6c0eb87b023d6f7adaa23d8fc5f2f1cd4448c7b307998ef0d25834e30"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
