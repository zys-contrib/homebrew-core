class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.133.0.tar.gz"
  sha256 "3538eaa10629e07d6674b1d1a5cad63e0bfa5db3e428fcc00fe65a2b6c898e7e"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "995d56474f57a1df5f9488919a81062bdfe1fb63e4a24569274310cce388c436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "995d56474f57a1df5f9488919a81062bdfe1fb63e4a24569274310cce388c436"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "995d56474f57a1df5f9488919a81062bdfe1fb63e4a24569274310cce388c436"
    sha256 cellar: :any_skip_relocation, sonoma:        "71b3ba44c43f6d1e136ec5d9d957026da4201a07940e5cbbe5668356e88b2d85"
    sha256 cellar: :any_skip_relocation, ventura:       "4c9408c5b2c1d5a8249899b3b18f6a5bd299a8c0b1615c843640e379b1b69a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fa27b1f7817957850103d2fa717c091e24a9bfdd6bd574dc31f734e8616687e"
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
