class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.47.0.tar.gz"
  sha256 "e4011e837872528aece36559981ee7e661f335b304b802150f8ef4b6c4331fee"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5d08bcd8609cd036f2352e6b5a29bdb160c5fbf742ea5d885c894a366af75c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5d08bcd8609cd036f2352e6b5a29bdb160c5fbf742ea5d885c894a366af75c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5d08bcd8609cd036f2352e6b5a29bdb160c5fbf742ea5d885c894a366af75c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6db457ab7ba1eed8b39ecede4749b6bd325d5d78cc1b8f9075dd18401c3ea200"
    sha256 cellar: :any_skip_relocation, ventura:       "6db457ab7ba1eed8b39ecede4749b6bd325d5d78cc1b8f9075dd18401c3ea200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba8916b8a6582a2f01581cfbbe248c08bd8418d68161842fc5ebf67d1ad36c32"
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
