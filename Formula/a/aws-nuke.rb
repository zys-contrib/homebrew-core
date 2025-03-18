class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.49.1.tar.gz"
  sha256 "bc1337828f1166916a7edb55abcd942bc89e4d8a54134716220ce7dc307514cd"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f145eb8617feb06d607f0818db68aa90f425ef4607a66f354a3316b2593f731"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f145eb8617feb06d607f0818db68aa90f425ef4607a66f354a3316b2593f731"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f145eb8617feb06d607f0818db68aa90f425ef4607a66f354a3316b2593f731"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cd496e6b0e73854f2cf5b36569652e3cb6df98ceb5e6674541f3017f39d4f7c"
    sha256 cellar: :any_skip_relocation, ventura:       "6cd496e6b0e73854f2cf5b36569652e3cb6df98ceb5e6674541f3017f39d4f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c68eb21b49f9027ef02294c7f6f53a430e1823e40c3a3cd08ca50a0ec5c4047"
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
