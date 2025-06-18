class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.614.tar.gz"
  sha256 "27ad7b233dc2b3849da33c7032cfdd8e6d6447f20dc2b13c5978356084a0ac3f"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3942581309c8d1b13a2a132184dfd43e52253feb8c0a84eb8a7f10117e99a09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42d162e2efec4bad38435cf2b8ffd02f567478d0e2ba73cbaff04810f8ad256f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4543d26406703c34853096834647da8bf0128ef1ffeb873773806f0b22f7d44c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa9caf412c050439edfea04c8a0750ec17fde56adb2139c79fb2c36825f5cba3"
    sha256 cellar: :any_skip_relocation, ventura:       "4be315084c45a3f306afbe1db252f227a785c9aa1a0c006a1c999d1c9d50c8f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cbd3de68f2113c771d37b801cc104e899ce26b61f20e338a2af4e6fdeae82b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee847b10adb9322bee05612dc65e0dbd3ea44b069fe05486b5cbc43ed6e1dffe"
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
