class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.103.0.tar.gz"
  sha256 "e38516d2c4acd9d7081ff5a20eba1bc71b791c463a6b2a09432504efdd2f90cf"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed00df33222ffbd3a02e901d32ff009c7cbb6836a3980dd2cfbde06b55bee48b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed00df33222ffbd3a02e901d32ff009c7cbb6836a3980dd2cfbde06b55bee48b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed00df33222ffbd3a02e901d32ff009c7cbb6836a3980dd2cfbde06b55bee48b"
    sha256 cellar: :any_skip_relocation, sonoma:        "274ee8389f880db0385b5f2cc94b2060d225805fba0f2f5111ca327d66c71840"
    sha256 cellar: :any_skip_relocation, ventura:       "dd5c85d63d0a4fe2ea6e84121f4356c98a1fbc2894f869eefdeb95ce2f6706e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9450890b00631bc3a4460d6d45a070eca1441a2ed8afa7cf68065f9e41d26abf"
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
