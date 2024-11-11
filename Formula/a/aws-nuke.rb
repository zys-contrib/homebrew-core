class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke.git",
      tag:      "v3.29.5",
      revision: "a3f1210863e65d48b74da1c302b15b0cc07c0d62"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb92386e483b7bdfe72e4f1c851f4575ab10d38b6d3c06a503b18f00dc3658e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb92386e483b7bdfe72e4f1c851f4575ab10d38b6d3c06a503b18f00dc3658e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb92386e483b7bdfe72e4f1c851f4575ab10d38b6d3c06a503b18f00dc3658e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a86e8ab7aa0a90afe7950654df4397e8a6b14d3cd69df63bd68a4d80006f5f28"
    sha256 cellar: :any_skip_relocation, ventura:       "a86e8ab7aa0a90afe7950654df4397e8a6b14d3cd69df63bd68a4d80006f5f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff179a841588fd55d70c07b5c6878c19517ef53158988aa96f9efce25d40833d"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.com/ekristen/aws-nuke/v#{version.major}/pkg/common"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.SUMMARY=#{version}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags:)
    end

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
