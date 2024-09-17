class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.68.tar.gz"
  sha256 "b615559e8cee659bc418a0cd3b74e07f9c4c940776a7388e32b6947fa3a880e5"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d6a9e63a8a99b284ed76590187c1e20eb19a826f32c003435f3353aacdc6ca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a51a865dcae80dbb628a5fe4f09a46784f9e90e9ae4b8c65d436d1e861221903"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db5da3ff7745d5192d9d7d9a7a96ef6332e7bacf10e67d57fdb0bd92f6a4b4fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "58a75e47df14e03679849388726c45d0a92386f510b3ac4822e7d4fa90d50bd2"
    sha256 cellar: :any_skip_relocation, ventura:       "7d101b1f3ab4c3093def6d2b1e1d374300222b8c317cb26f3de35d0ed6e8caf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae6b6abe5111d8886ecf8d4f7857b110b72fbdb84a58550491575e2e45e83a5c"
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
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
