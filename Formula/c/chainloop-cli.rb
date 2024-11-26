class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.129.0.tar.gz"
  sha256 "bc8a961ad57528eecb5b06515926499e8de221f7daf5de15c7f496d8450641a3"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6214a4858fb4fa0341db4e49d8d8d18f8b2081480c1b3cd2bc45513a81778395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6214a4858fb4fa0341db4e49d8d8d18f8b2081480c1b3cd2bc45513a81778395"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6214a4858fb4fa0341db4e49d8d8d18f8b2081480c1b3cd2bc45513a81778395"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fe8794ec71605470cc4ad214a5b663c141e6025d80c167297b90be1cee9af58"
    sha256 cellar: :any_skip_relocation, ventura:       "4015369fdc9356aea70ac0b5278bdebc0f181a493d20cafc05f33a545f7c9a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0627dc5a9f173685c1349d07f5a14f32b81a478e28e7265e894c8a2736ecdccf"
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
