class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "808601e571735cab606612116a6783e65b89214662754e9a281c5c9cd0be1e41"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd1c3247980986969db7f75480840dcd35ed95d67b05d76a0136c4605dd8c987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd1c3247980986969db7f75480840dcd35ed95d67b05d76a0136c4605dd8c987"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd1c3247980986969db7f75480840dcd35ed95d67b05d76a0136c4605dd8c987"
    sha256 cellar: :any_skip_relocation, sonoma:        "425f8ae049c8762e24e65ed94f3592d1e9496456366215b9f4a19cfeacbcef44"
    sha256 cellar: :any_skip_relocation, ventura:       "425f8ae049c8762e24e65ed94f3592d1e9496456366215b9f4a19cfeacbcef44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c30a000fa81e3c0708f80ca8b72268694e2a3b596166037a5841a68ba1a7c202"
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
