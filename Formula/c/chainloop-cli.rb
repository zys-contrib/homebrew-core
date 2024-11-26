class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.128.0.tar.gz"
  sha256 "9ae9364af5f3510320ef40081dc47030670a09da5ffa12b132876a04e4623b94"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "055e4ce2a94b6d07813e7d8f2bb73b50efab0a897282fa6baacefaf9abc651b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "055e4ce2a94b6d07813e7d8f2bb73b50efab0a897282fa6baacefaf9abc651b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "055e4ce2a94b6d07813e7d8f2bb73b50efab0a897282fa6baacefaf9abc651b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c428705aebaada76418a6173ca50637c0c4080ed025c3f68d0ce852ab150255a"
    sha256 cellar: :any_skip_relocation, ventura:       "f3493af86193104e832f13dd74d88879ce9b6036c387c50e21ddd24aca9f0485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4a8213e409b569663d9f57916a579f399ac475cd70fdc7decd228a4f7f23b8f"
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
