class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.41.0.tar.gz"
  sha256 "a3befd2a621aa73a6b514f94d78f93369a6c100b756e6b9677f796d438c244a5"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9f79f15e35ef20152ab698ea7cdbb3ff6c9dc0a150da7013397345d79c0ff12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9f79f15e35ef20152ab698ea7cdbb3ff6c9dc0a150da7013397345d79c0ff12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9f79f15e35ef20152ab698ea7cdbb3ff6c9dc0a150da7013397345d79c0ff12"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d0ce620bfbdc5725017791c3d8aaa403e42d032f7028f62371ab58a97c8d679"
    sha256 cellar: :any_skip_relocation, ventura:       "6d0ce620bfbdc5725017791c3d8aaa403e42d032f7028f62371ab58a97c8d679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dcd4c6ddb63a7c21c3a5802df8a491f626de97bfd56b86eb9c7fcaa767444dc"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
