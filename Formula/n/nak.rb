class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "e1324be886a0cae4b49d9079932e5c8c7d85554cf1e6e62e0c3cc97c537cc7eb"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bca23390c7dccbf54692fd195dec233fc7f28d8f27da6b80bd993bdaaca2a2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bca23390c7dccbf54692fd195dec233fc7f28d8f27da6b80bd993bdaaca2a2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bca23390c7dccbf54692fd195dec233fc7f28d8f27da6b80bd993bdaaca2a2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0e0a8cfc6815cbafbbad0e1814c74c279c003e0165f107d26dfd2fea2d2ebd9"
    sha256 cellar: :any_skip_relocation, ventura:       "f0e0a8cfc6815cbafbbad0e1814c74c279c003e0165f107d26dfd2fea2d2ebd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1d4de00869867143045feb373045d94b501aa24d232d29f30638b6b2524da5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")
    assert_match "hello from the nostr army knife", shell_output("#{bin}/nak event")
    assert_match "\"method\":\"listblockedips\"", shell_output("#{bin}/nak relay listblockedips")
  end
end
