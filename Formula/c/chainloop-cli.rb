class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.116.0.tar.gz"
  sha256 "53af5c3f54afb88f2412a3085bc0ff4455cedb474aa1d60a8e133274d77f90f8"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02b6fee23bb117e0127303c30b9703db90781f942e82a7c434c2ee84b2fdeac5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02b6fee23bb117e0127303c30b9703db90781f942e82a7c434c2ee84b2fdeac5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02b6fee23bb117e0127303c30b9703db90781f942e82a7c434c2ee84b2fdeac5"
    sha256 cellar: :any_skip_relocation, sonoma:        "39490f58d1761d9aad70f33845a7668eb1da9628dad2e707e6caa35979585427"
    sha256 cellar: :any_skip_relocation, ventura:       "ff65df334a039b34ab4dbb8747b5b0d40b4c8d7fee0db31510966d9285692c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adbd2843619051f8a1474676eb0049abc4ff690a3760fa3408fb2260ee55b893"
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
