class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.50.2.tar.gz"
  sha256 "172ba1e0f20d6c39a17b5739a0834076ab57f6f358c9a73303b0e97a0c2347fd"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "803118cb594fca0d343c1b588b990977d062a9dfadf65a75d6ae5fd24cbe4a85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "803118cb594fca0d343c1b588b990977d062a9dfadf65a75d6ae5fd24cbe4a85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "803118cb594fca0d343c1b588b990977d062a9dfadf65a75d6ae5fd24cbe4a85"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7de6d3d012b1bac47d3122d4ee600e7286026f4c3d2714ade9e1a3ee86e8c8d"
    sha256 cellar: :any_skip_relocation, ventura:       "e7de6d3d012b1bac47d3122d4ee600e7286026f4c3d2714ade9e1a3ee86e8c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "642230d7fbd464407c343edc8fb71f1a1c071af178fed2821c01e3492b5d7775"
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
