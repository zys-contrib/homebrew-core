class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.25.tar.gz"
  sha256 "e6c1fae88500ad5ef9a3a62cd19f437d8fc40585180c7290605a32b69a1e1355"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6245b9e161ec32bc456c1fbb2e7ac773fd94467816cfbd07a9e2e64b7f05691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6245b9e161ec32bc456c1fbb2e7ac773fd94467816cfbd07a9e2e64b7f05691"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6245b9e161ec32bc456c1fbb2e7ac773fd94467816cfbd07a9e2e64b7f05691"
    sha256 cellar: :any_skip_relocation, sonoma:        "55fb363c73c035adf73dddcc36b2132c355c8742c13b8f75e5d792f4e9f76b85"
    sha256 cellar: :any_skip_relocation, ventura:       "55fb363c73c035adf73dddcc36b2132c355c8742c13b8f75e5d792f4e9f76b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a62fecaa416d531304c3447573c383de1e3bd450e9bd15912458560f296bbb8"
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
