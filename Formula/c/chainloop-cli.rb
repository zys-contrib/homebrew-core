class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.104.0.tar.gz"
  sha256 "9092a1c3183f25814d98c75273205071dd10730b8873463823de6e3a856254b1"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c0df40631c6255c977c126c70329e828a1a244059813615d2f0936d03be0e98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c0df40631c6255c977c126c70329e828a1a244059813615d2f0936d03be0e98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c0df40631c6255c977c126c70329e828a1a244059813615d2f0936d03be0e98"
    sha256 cellar: :any_skip_relocation, sonoma:        "43b01467e94f3e1ea1c4dfdb5d4d02924b8335ff3de7d4b7a2e17dc0b51dcebd"
    sha256 cellar: :any_skip_relocation, ventura:       "f76695a90bd3f652464f1c577751acb98eb5f0dd1b223e5624beb4674c2d9edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a33cd39584410619ccc186c56b0ea6667f497bf5b28c1d1f8abec77cc323b314"
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
