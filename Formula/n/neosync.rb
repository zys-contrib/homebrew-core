class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.63.tar.gz"
  sha256 "5f5c1344169d9969aae6140740aa91a8c86acb84f3dd52663a4ab17d815922ad"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7347a16ee396f4461b04a9074f6370edac5f2d84f0917fd0924d2a85439e80e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6666d34800d5974d14e2f6ebbbb0b868f758145efd53007998f288f851b2d17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2625286eba79add00a6aa826f2f36bf14ca1da2c7b6f352f6e9d2ee40d893c9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd61da3df5d82341f429418859d688213b565017b1a0516dce3419c3a0425157"
    sha256 cellar: :any_skip_relocation, ventura:        "00785fbcb7e502602349b8b9c68406b79f5dff33d10d18037c64ac84162c5b2f"
    sha256 cellar: :any_skip_relocation, monterey:       "0e2a16dd6e14ab04e565923099b3346a2c822ddd0794d8de79719efb439caefe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd3b209c995d4ef4414e22e893f89d6225f010d551705761e8da99934e2daa4d"
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
