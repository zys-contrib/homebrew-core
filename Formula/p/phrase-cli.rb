class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.35.2.tar.gz"
  sha256 "687b8a28bc66db778d89fa23d5e7af5460ac2134bd10678efa9b7e27f395b0d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee2bf651facb7124fec45e5744fcf6675c966f303ca9df3efbf6f3d9d8f8a15f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2bf651facb7124fec45e5744fcf6675c966f303ca9df3efbf6f3d9d8f8a15f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee2bf651facb7124fec45e5744fcf6675c966f303ca9df3efbf6f3d9d8f8a15f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fb496815098a24aecf1e2c030f6220bbf1b8c86cd7e15200f610228db90a527"
    sha256 cellar: :any_skip_relocation, ventura:       "5fb496815098a24aecf1e2c030f6220bbf1b8c86cd7e15200f610228db90a527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "618d2d20e48d15440f038e7ce79d0f3078d0e3b15380a007ab36d0cd33f68304"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
