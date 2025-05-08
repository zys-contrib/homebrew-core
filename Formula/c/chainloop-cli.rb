class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a23597a7f69524b652d2cbde7ae3f166f3580bb3c2bd9027daf92147646f46d2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d04a9f32b1baa7a882b58d6ba939cbf739b92606aa0b45a1e16a0f7f7a7f6bfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d04a9f32b1baa7a882b58d6ba939cbf739b92606aa0b45a1e16a0f7f7a7f6bfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d04a9f32b1baa7a882b58d6ba939cbf739b92606aa0b45a1e16a0f7f7a7f6bfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e269527784f7f9be9bec59e7d0cbafbb76da857f3b3efc0d8a722101781e28b"
    sha256 cellar: :any_skip_relocation, ventura:       "6837c2be925c648c2c487deccc21483ca9c2f7090707d0086803e2f318f6bc6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc9062baf5d0535ce753b34e3e9f098677e7b37ad9fe91781f5e3464e9889f45"
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
