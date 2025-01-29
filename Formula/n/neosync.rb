class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.11.tar.gz"
  sha256 "d7d41f4b8d1dd9170df7be7012e1c8680bbc273a15011e2a518ce337f55e0c53"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b34971d6b2f2ba2ec708bcf3618f1043df1322fc1a2d9a371904fc8e56b14f3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b34971d6b2f2ba2ec708bcf3618f1043df1322fc1a2d9a371904fc8e56b14f3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b34971d6b2f2ba2ec708bcf3618f1043df1322fc1a2d9a371904fc8e56b14f3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d816f75cf67d217eda923ca25c0a7f31d5f95a08a6a43a08353e1480238c559"
    sha256 cellar: :any_skip_relocation, ventura:       "8d816f75cf67d217eda923ca25c0a7f31d5f95a08a6a43a08353e1480238c559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d00b1d0e8da99fbaa139a80d89831f76c7ecda4044308e371316696627372462"
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
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
