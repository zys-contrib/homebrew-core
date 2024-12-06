class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.96.tar.gz"
  sha256 "b5f0d11a6eda3fedbe4f395a20732d3e664d617bbeb97178ac8e2a86aa5f9388"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa2fb2b4dd15145d59411986c2f5840821a14339497358d94f40e715065fea48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa2fb2b4dd15145d59411986c2f5840821a14339497358d94f40e715065fea48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa2fb2b4dd15145d59411986c2f5840821a14339497358d94f40e715065fea48"
    sha256 cellar: :any_skip_relocation, sonoma:        "255b56ecd38f2d13646182c4d422f1285777077256f99c60a84df86c07c357a2"
    sha256 cellar: :any_skip_relocation, ventura:       "255b56ecd38f2d13646182c4d422f1285777077256f99c60a84df86c07c357a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa3e6b2bc597ee72062169c3403e5d72eb237a888f058777191ffb1bbc67d4dc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
