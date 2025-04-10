class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.0.88.tar.gz"
  sha256 "752125949347cf697aade1a23369c3b7b86dd9011b3be1459c4843c2025ea0a6"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30f23278c0d942b21726fa9156d64c076de478a82a550ce176b606594e7fb27b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30f23278c0d942b21726fa9156d64c076de478a82a550ce176b606594e7fb27b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30f23278c0d942b21726fa9156d64c076de478a82a550ce176b606594e7fb27b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a15630f554c3ce5818e4b119dd4f4ad292361b84af3e73c5780c104fada85069"
    sha256 cellar: :any_skip_relocation, ventura:       "985490edfb60fb181c7f01323767404aaebf1c0853c78daf7cdf9e807e8be24c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "922edad4d610f23965123139439a96bbde0929586fff2a5b61abbe8e55e4b86d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
