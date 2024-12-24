class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.37.0.tar.gz"
  sha256 "d5db3ff5c51c206ff71427cbf3426415adfaf5ac57a9df78f9cc160cf9d2db2e"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75305d4eb813f6381b8f9c3f1e8d8cd79b97347c3ab224e5bf8f07c3bd63855"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b75305d4eb813f6381b8f9c3f1e8d8cd79b97347c3ab224e5bf8f07c3bd63855"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b75305d4eb813f6381b8f9c3f1e8d8cd79b97347c3ab224e5bf8f07c3bd63855"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b05367cfd78f78357bdd513cb1160ede97b43984bc80fb2943a605ff5035798"
    sha256 cellar: :any_skip_relocation, ventura:       "3b05367cfd78f78357bdd513cb1160ede97b43984bc80fb2943a605ff5035798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fad571468861bdca573e521a9c657d8f7db7b28a95c43f5907163e17618c16e5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
