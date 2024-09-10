class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.542.tar.gz"
  sha256 "1553c42c51069ce4d7e1ea23cc53e70abdeb56e24a85198d1c1aefec5f8032ba"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf6394ba0a34f9c9a2fa1aba97c8686a71bc4691ddf19003e18d12ba25345e70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bca8c988abb09c8ddc536dd05ba51ea1b415ea464aba014d8e17694912a9bc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0d0c1373dceae6f1ab0cfe823d09291124dd18ef5b9acd165eee958776201a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0738c2e1da7d6e1af3f2012f5f0176ec28dc4dd9c0694d70d2a856d0d52beb0"
    sha256 cellar: :any_skip_relocation, ventura:        "1468a3373ca8421eaa5858563bac180a14b5fee38063f1ba80dd18097098dfd1"
    sha256 cellar: :any_skip_relocation, monterey:       "92a02e33503e8a15d5830ebeb180140bc3937d0d91ea0a9e0bec614537815c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17a569f6167adf382c41a95c9d61ca57a0f9100296daf593056f2a4a76e6e6d9"
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
