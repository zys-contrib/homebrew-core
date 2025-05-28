class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.606.tar.gz"
  sha256 "018d8aa21e90267d2a34543c6c98a9b209336d7b886441b0d910f0a445883d87"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b374cff1656a94b3671ac3d21a017072753459afe5845b86147ff800cf9f663"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5668f2420cbf1f559c968f354b409191a360efd339fdaf6ff4e4546784935928"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a2780c19ad43a1e79c5166e28f2f23317ba34688932fc356c44b9b5f523b924"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4abb62453d19d6f849a4407a5fc9c7d65a80d6e273a6e46d6e4775a9ce2cc1f"
    sha256 cellar: :any_skip_relocation, ventura:       "f3ded40ca2f5349ef66aaaab400e0ca45f77dd7428989625eef8b0acdf39d444"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cec950aff29e8fabcd972a68110acafe3edadb01ff59e1bf4477370f06aac4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13bd7a09d63b19634423e5fe6f82093c6686f534937cc96727764edaedc0b391"
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
