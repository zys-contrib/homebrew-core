class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.18.tar.gz"
  sha256 "e74c6dc31f300ba361366f767a874f7eb748f28e7f90d2eb94dc0c4fa861b038"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e1347cc46b59fa24663e3ebd3ff6c5f4bcfa4bd31176c3026e6122371157fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21e1347cc46b59fa24663e3ebd3ff6c5f4bcfa4bd31176c3026e6122371157fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21e1347cc46b59fa24663e3ebd3ff6c5f4bcfa4bd31176c3026e6122371157fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "23b585cfdb74564ec75fd4fdd9aa4a6bd13aaf40bd37a8e043fedae48d34f6eb"
    sha256 cellar: :any_skip_relocation, ventura:       "23b585cfdb74564ec75fd4fdd9aa4a6bd13aaf40bd37a8e043fedae48d34f6eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea0e370bf5cdc1faf736e79d8938b704916a2dd89b449f4073f7bd676345cf81"
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
