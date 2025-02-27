class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.174.0.tar.gz"
  sha256 "a6baa80f921056080cffd1e91410aab7edbd62751a392b695941f1fd20ab5da2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68cc8fc61b86b27531b1e2399269005848a5e7598a4b388ea0b1cf85d0936c55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68cc8fc61b86b27531b1e2399269005848a5e7598a4b388ea0b1cf85d0936c55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68cc8fc61b86b27531b1e2399269005848a5e7598a4b388ea0b1cf85d0936c55"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0c3ff713c831e8272592eabbfbbf5e663781265ece1754ddd93ec0d6e45249a"
    sha256 cellar: :any_skip_relocation, ventura:       "b1debddddb3817809f0e79558f7c9caf79e07c9fba65630edaa31124680983f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10fb3d2edbe6c0f1e4f66ab7061f96941f58b3afcb4069985ad5a039de3911e4"
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
