class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.46.1.tar.gz"
  sha256 "2b86ccf9e847b98491b552db73dc20a272ce1c3c8662eb3a3b1e811ac2574ba0"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50dc9e28637c64d50c40eb4053bae2873e811fa0e98a6fb5f37b6ee7309bbbd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50dc9e28637c64d50c40eb4053bae2873e811fa0e98a6fb5f37b6ee7309bbbd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50dc9e28637c64d50c40eb4053bae2873e811fa0e98a6fb5f37b6ee7309bbbd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab37f3bb6a13ef5863fd106b72bfe7093054f09ea6f75bcdb0a766445eff365b"
    sha256 cellar: :any_skip_relocation, ventura:       "ab37f3bb6a13ef5863fd106b72bfe7093054f09ea6f75bcdb0a766445eff365b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61067cabb50faaf2f7838841fadff9e8d04b6fc7f7b36ed76ced14e5a5367dbd"
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
