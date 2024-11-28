class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.33.0.tar.gz"
  sha256 "7b87180895c6c1729dbf803dfb90b2ca1d4ec9b92198e64cc6f1bc225965e6e1"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "358b0064246435d6039e72fe61e8204e1770f41057dd305c0271bea5c1fe1e41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "358b0064246435d6039e72fe61e8204e1770f41057dd305c0271bea5c1fe1e41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "358b0064246435d6039e72fe61e8204e1770f41057dd305c0271bea5c1fe1e41"
    sha256 cellar: :any_skip_relocation, sonoma:        "331ec158ff4032830547a7056c9ae8e15e96a7aa7b27dce24d0fd088aaf049ce"
    sha256 cellar: :any_skip_relocation, ventura:       "331ec158ff4032830547a7056c9ae8e15e96a7aa7b27dce24d0fd088aaf049ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44367fb072b9a39edc68d7bc10674b5c6c0f0b94244a735a38c223abd4c93683"
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
