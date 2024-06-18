class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.37.tar.gz"
  sha256 "dac34815ad96ef7a6b942aea2ad193253486c595a39b2fd1613f7bd28e5eab17"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbeaf50aa1af09344503d2ac87020db2249ee628042b8bdadfd7184ea61b3afd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ff2da82b836c52aff2e04d358827b3f8b031b7c889c24c3f58beb1c23a06d35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fa7f73247d5699252c141313c38501fae63dc6885d8d61a616fee2ee78c0099"
    sha256 cellar: :any_skip_relocation, sonoma:         "03f95b028af4b62da488e5a325961af7a0d23cd05c4a0770025d8081febe0fab"
    sha256 cellar: :any_skip_relocation, ventura:        "c19e0a208e7c9a3d5ca7646e7c78bf58bf1dcedd8df14346a85d6d556ccd02ff"
    sha256 cellar: :any_skip_relocation, monterey:       "a8db57d1700262501345c94483e27e2fe519c15c6b476c46590318fc01704f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9576f47aea82bd639163685d1ef70cf8a5d3e0a21c675ce2c10fb3b558cf79f"
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
