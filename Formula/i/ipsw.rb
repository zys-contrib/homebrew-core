class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.577.tar.gz"
  sha256 "688b64cee6447f28b5e6cf3899b372e40e97f3edde8190eb9e45b4db23126af9"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e707c51ca64e332d9358f7ec39ad60706e50105122b662d7dfb758f05da712c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa6d8163cc1f457e4e2d5e4d1c57eef5e29282d733087dd043daf95ebd8c2fe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2124c11dfe7008ec3c287d51ed64c2b29a3e3102bd05ecceb37e8e4074348754"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fcc8b99df9d6d83c74aa98c2763fb2827809bd7e5e76dc04f7eca06f3703aa3"
    sha256 cellar: :any_skip_relocation, ventura:       "2e05013c46065c8674fc83f668929dda19a6642ea8bd25ed17355f9aa01f043e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb1f96e7df909677148c4922ea28f5d724b0a485a5839df9488e345c7c6e9a18"
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
