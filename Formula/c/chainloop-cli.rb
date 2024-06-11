class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.91.2.tar.gz"
  sha256 "a7edb214dc3c2f87bae70041d31293b778a1db4ad16f98fb42a63feadf0038f9"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c5515dfffccca4b3920a8520dd268417df65a2c48fc59be1c723b8656f24531"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee51eed8bbea34382e5b085c221e2cae59175b554823bc19deca6394b62e5659"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f80c6b0051a98045e1fe786501b8447cd43bad2c4c8b0572b4a0f410db15a85"
    sha256 cellar: :any_skip_relocation, sonoma:         "34c2a1dab2bffbfc9dcb65661ffc3479601d1c91cde5ae31b091f1e5744847f9"
    sha256 cellar: :any_skip_relocation, ventura:        "d2a5f57cb4c6808c6db769e5ada2030f674a1b6962b04a68d80ef2388f1e879e"
    sha256 cellar: :any_skip_relocation, monterey:       "a81b86fc20ea8b42c7900e140a3325c1f1ec4e15ebf81d10aeae4c2c41b46370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a674e9c8b6d7c16d06c87bb0ef0b3e8f9a1723f0e9364c4f343fc6c861caaf4"
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
