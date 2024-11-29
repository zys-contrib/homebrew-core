class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.134.0.tar.gz"
  sha256 "a990342c02e6a3d340cb03096fc9569065f043b69cd11e2af605348032325d9c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c609f07a31dfaf6f1d0dbf8b77daf7d9d7d3546a8303c125f3cfabd4ec8d2cb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c609f07a31dfaf6f1d0dbf8b77daf7d9d7d3546a8303c125f3cfabd4ec8d2cb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c609f07a31dfaf6f1d0dbf8b77daf7d9d7d3546a8303c125f3cfabd4ec8d2cb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "42f98f7eaf46c0916e88c3ce002a338d345cd7a1abaeaff7386a93995931c995"
    sha256 cellar: :any_skip_relocation, ventura:       "8d3eaaf5749a476df78e03e703931dc34736068598730f6465797131028884c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc53573a48da2dcc8413612a45fd608788b1c610da03102c17bf18726e073e59"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
