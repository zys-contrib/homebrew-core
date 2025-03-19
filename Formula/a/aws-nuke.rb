class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.50.2.tar.gz"
  sha256 "172ba1e0f20d6c39a17b5739a0834076ab57f6f358c9a73303b0e97a0c2347fd"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f010092a68953c6d07b425278bf2b048e11a45a36b846d8e352108a79779ae61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f010092a68953c6d07b425278bf2b048e11a45a36b846d8e352108a79779ae61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f010092a68953c6d07b425278bf2b048e11a45a36b846d8e352108a79779ae61"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d8c4d6917974641cb719a96290a1ef04a79654819e81d690e57341be769c05c"
    sha256 cellar: :any_skip_relocation, ventura:       "2d8c4d6917974641cb719a96290a1ef04a79654819e81d690e57341be769c05c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab4487492a82b490c5c5eb7b994afacb19603045c8237b4d8cdd59a8726de33f"
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
