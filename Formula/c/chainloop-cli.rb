class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "f822e96b54e39a89abc5a73def05ce4b9e923dd8ca372569bd38e9de8e6573b0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b436623babd01466640812dd64c71cbcafa5949c589c2faa1a116d190a4967b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc4cd88020dd87b4e2c2cb219234166cc62944433cb63d95532ae62639eded7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "103b359db8364dd116d4ef97ab4b1718fbe02c881f6c836a36c3c48473c3682d"
    sha256 cellar: :any_skip_relocation, sonoma:        "53aca6d105933018a893e5f3877655bf590e93915f5106254c5f997aa6a636ee"
    sha256 cellar: :any_skip_relocation, ventura:       "6063d335aca5960aeca6144ba80392b939bd0050de4ea3ac804a69402fbecf9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b2a313d659f5f8d7d866bd0a38143ea19df405aa214c952a0c02ce88913b6bb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
