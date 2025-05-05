class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.598.tar.gz"
  sha256 "d33036458e33c66b15c08a4fbe9a2644881f78331ddc2997b03d336b7a9cb617"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "529b73c7ea66eeeb9470a8c4b1b47814b138b85721ecda902fde0db750ae4988"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e75c22110321cc39bc5c2f7d662961e5064c0b652c33d995cfa24fbecc90dd2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "733017376ee8f083c64e6685c83e7f6db9431094b1e143f27f0cfa8752f5e263"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fcaf07c28f7b824e725922c3b410d051de570b5542e259b58237002b24dc1e6"
    sha256 cellar: :any_skip_relocation, ventura:       "47f877d1698b447c74b26de0305ab70f72f7a5941b980821c79eb8628389b87b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc690ecefe8a3579e0fc7e5958755f8a76ebaf172f8e405b9f8dc92987f60baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "936aef356088a51447df3f6c1c35fb3bf0525307d941bc5a99ed8503a6f9e4bb"
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
