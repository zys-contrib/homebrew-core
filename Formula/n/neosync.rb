class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.91.tar.gz"
  sha256 "0357a050f8339cd545bef2cc87c3c0222f670bb83647eb5a055a077938028dc5"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b328f16f9279a62992cd4d84ab4e4a38c48006fb52fef3025d1ffe17de985a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b328f16f9279a62992cd4d84ab4e4a38c48006fb52fef3025d1ffe17de985a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b328f16f9279a62992cd4d84ab4e4a38c48006fb52fef3025d1ffe17de985a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8900a7399c7ac1ee5bd3136befdc7769f9ac3b2d27ce8b8f94299849eb2dbef1"
    sha256 cellar: :any_skip_relocation, ventura:       "8900a7399c7ac1ee5bd3136befdc7769f9ac3b2d27ce8b8f94299849eb2dbef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eccf1b361d21d03f8777055ea7dc0295c08d255f093e79a87e6e50abff1bded7"
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
