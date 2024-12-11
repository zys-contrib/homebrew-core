class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.98.tar.gz"
  sha256 "1e8a74ed97f2e73c1282c33be05f2b036b8d804a0ca9a7a56a0d50b66176fa94"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "260a5dd04976cc947b5a5bd9d67b63dc706d1c39b2b7ca7f9853007986a61209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "260a5dd04976cc947b5a5bd9d67b63dc706d1c39b2b7ca7f9853007986a61209"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "260a5dd04976cc947b5a5bd9d67b63dc706d1c39b2b7ca7f9853007986a61209"
    sha256 cellar: :any_skip_relocation, sonoma:        "66fcabc825bec723fcd6ba730e952b2798727b375fbbbdde935da9e91c8558d8"
    sha256 cellar: :any_skip_relocation, ventura:       "66fcabc825bec723fcd6ba730e952b2798727b375fbbbdde935da9e91c8558d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f7f7680d5da51ffe6ea67a73bd87909c70bf076bc50a741d253f00c99bc0dc"
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
