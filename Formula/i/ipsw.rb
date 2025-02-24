class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.575.tar.gz"
  sha256 "6b668e2a5d9fb4b21dfbfe8742c6ae07b907743499e5e5a4b81ce42d15d3868c"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "203f9c2b0870242c42999fc777c91cd8285a6f976144fe8919ad759c0f2a7fb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f19c70bd3cda2f0ecb7ce686051cd21e083ab6e02f94ffb38ed419a528c9a20a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bda8e4ff58628e5dca84d097d7ccafab93b052c1cef6a31f20fed7f416eb97f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfe1f63f3371b42b7a934e49b09b368ddeb6b134b68c11d60ed4310b0486a595"
    sha256 cellar: :any_skip_relocation, ventura:       "78ec0574066bdb2bb9b180f0b3e40c1b20ed015f5d61e07e55c8950f355a2694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79a66cbf74f323ec8a961631665a64e8c48d2d71e556fbc81dd3134ab600a027"
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
