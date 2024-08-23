class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.55.tar.gz"
  sha256 "1f4eb491d91a940675e8f3e27e1c81155780944580bfbb4b1eeba6af51884785"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07165863e52b54983ae1a1b0e056a342e56800e9e5da8829b4385feef6ab91d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f768c4ca3ecab2d12e6a6616550051a998d68ea686e983d31ceb79a428a703f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efb18139d9bcc803f3a089c3b40f45576a2c97ded3a50b72d9e41ac484ced4c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7469f810850e62444a7c0bc218aa78bf890fdbebc9f7f71629347b8ea87062c3"
    sha256 cellar: :any_skip_relocation, ventura:        "918c17e93b2e6f3dce004f8cba04eb516e9e110ab76155142ee0b033d4680450"
    sha256 cellar: :any_skip_relocation, monterey:       "1bf577d9c8ca4e38d87c44878842ca9baffd7473244b9a812e1b76565052dc3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4c0f74a8e9c1caced4943eda191a1a421297f00d1c151f850346b6845364819"
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
