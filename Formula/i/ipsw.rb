class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.561.tar.gz"
  sha256 "90de70df43a0432b58f964416f44273f384e1ab92cb9a5b86e50171634ea6534"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35a1fc12e91cad407b2f6dc885348435a3e54bd39bcbe7fb30262277c29a362b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "702fbf68680926ca427b87234a9a5cf7d5f0f44b4933b79ab2d1d9e26c486f01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d2a65cac0b47801477eb72fd92a9f30c35dc977911fa3587e349ba13a2b2583"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f69b13ecec444fe3d58a56e151f0de403ce89280c3c40c870997353458c2c97"
    sha256 cellar: :any_skip_relocation, ventura:       "e82974a7e39756aed32a76db44841b472fc073bc4cef5e1902973f4df8a50f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5744cc09a5467c618b91a78a34b79274ee7c77f5cf672e92151a9a340a49a169"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
