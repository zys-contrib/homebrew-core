class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.33.tar.gz"
  sha256 "7c927e4010c2461e2b7c7ba18a6dbc5a80146201822360d11720167ca4ed868a"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c65e01224aa221cae99493256f03dcb973bb7aaaa8c87914a2655124ea5c827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c65e01224aa221cae99493256f03dcb973bb7aaaa8c87914a2655124ea5c827"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c65e01224aa221cae99493256f03dcb973bb7aaaa8c87914a2655124ea5c827"
    sha256 cellar: :any_skip_relocation, sonoma:        "24feedf3dab9334e6750246944ff079ddb4e75ed30bfcafdf48509b94a241520"
    sha256 cellar: :any_skip_relocation, ventura:       "24feedf3dab9334e6750246944ff079ddb4e75ed30bfcafdf48509b94a241520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40ccb200f68662cbced280b01a6da91df5948ef321a048c5cc0e40f4753e9211"
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
