class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.35.3.tar.gz"
  sha256 "65e0f9bc1586ff5fe83126ef1ea321faf5316e25b7524c77fa576c44e9452407"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7afb77213a1dd8ebd5a9b633ec336fb39a4cd1a708e223ccf17d11c45117ca78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7afb77213a1dd8ebd5a9b633ec336fb39a4cd1a708e223ccf17d11c45117ca78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7afb77213a1dd8ebd5a9b633ec336fb39a4cd1a708e223ccf17d11c45117ca78"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eb612c949ab7067b2f8d4f9ffcf3c89cd508d039e9b0f9734961c9d7415ed56"
    sha256 cellar: :any_skip_relocation, ventura:       "2eb612c949ab7067b2f8d4f9ffcf3c89cd508d039e9b0f9734961c9d7415ed56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50feda86bf38cb3da51953f6601ba679dd3ff835b996a4f46b4764f49ad55a06"
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
