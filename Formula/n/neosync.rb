class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.29.tar.gz"
  sha256 "e790873c4a9b1a18153ef572c447daeee65d7ce90d4ad2b9afdf82b56d816ecc"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58d3cf443705fc7de803d0cd15b6b49cfebbe10d5200e866b9feae8a7c34b7e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58d3cf443705fc7de803d0cd15b6b49cfebbe10d5200e866b9feae8a7c34b7e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58d3cf443705fc7de803d0cd15b6b49cfebbe10d5200e866b9feae8a7c34b7e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "30ac661a8c4ecb582d6ffc54ed9c1d76b42826ac7d2e83069b42d5dfd3f7a518"
    sha256 cellar: :any_skip_relocation, ventura:       "30ac661a8c4ecb582d6ffc54ed9c1d76b42826ac7d2e83069b42d5dfd3f7a518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01903830a0a224530909129463c46d3a43547f0030a97266ba6da55eb97f8687"
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
