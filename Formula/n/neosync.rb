class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.37.tar.gz"
  sha256 "38b9588fdb55c14f3569da2e2be6c3ff128132871f175c43cd211b5a3f59fa63"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57b3ec902321363eac4e1da3960af15d25269b118e4b2fd510f247d2bc063572"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57b3ec902321363eac4e1da3960af15d25269b118e4b2fd510f247d2bc063572"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57b3ec902321363eac4e1da3960af15d25269b118e4b2fd510f247d2bc063572"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b8ba8212387cd5cf64690a20fde68266c540157c7c7541bd56b94892b6225a"
    sha256 cellar: :any_skip_relocation, ventura:       "d3b8ba8212387cd5cf64690a20fde68266c540157c7c7541bd56b94892b6225a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4234220a82724a28e2eeb48311a9f6bc899c9a92fdb77b683be3ef720ba4e00d"
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
