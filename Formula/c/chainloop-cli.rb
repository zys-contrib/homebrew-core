class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.158.0.tar.gz"
  sha256 "4cc984de649086d0e551f0516e3aa9e058a85e6c71240dcb8c33dc76154d32c0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7431c9ea3a4f0ff98b075d6ff75f6b94f7c021b2d9115e2d2ba7def962224a7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7431c9ea3a4f0ff98b075d6ff75f6b94f7c021b2d9115e2d2ba7def962224a7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7431c9ea3a4f0ff98b075d6ff75f6b94f7c021b2d9115e2d2ba7def962224a7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "178070f526c34fa7a6732d19e2abb62ef9f0e80c40b20e70a36fcb733d2ed7e5"
    sha256 cellar: :any_skip_relocation, ventura:       "192e3fa799f1493b9971343246f8619da249075635a034c65093c930360b186a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bd84927591f2bb15d19a019a1ea6c50ae2e6744bf293551da5859b6a7fecd20"
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
