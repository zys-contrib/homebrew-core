class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.596.tar.gz"
  sha256 "6e0145f60e4cfbe3be700279a753af7010518346c60ee0b2bae0e085d52f4997"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08d98c3e0646f8955bae7726faac3c561929a657ecd30955158f8058420adc34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "290cc9c1422e50ee5d9fce9db037df1aa1dc3d3a9a47acbfaa71b9f2b94514a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "569405340d3f865fd98d5fe24f1ab589bfd7076060b89d4b134c42c7e153ba87"
    sha256 cellar: :any_skip_relocation, sonoma:        "c71f1e5f51e827f19a39e5d3985f68c151202b9656345b8338c1d31c23d760e7"
    sha256 cellar: :any_skip_relocation, ventura:       "a18ca697b46725011f3c23a2f2a191b4a44353b77c18bc5fc5c618539aa49b93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b91af188e56a5f857f4768e169428f1b90133d7b4ceadf3643cebcdcd699c54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3956a057462b6a520d68ece9ff9f26fe6f0526a994c591ccfa8193020f8cdaee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
