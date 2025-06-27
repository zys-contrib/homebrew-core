class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "50e8d8fee42548d95fbf1663baf5b8a7b56fe232ed3242da050acce6d522b01a"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d251de9a637a5934ae6cd19a91fe99aa763b24c677329a8b8f28224a0e8c5ab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d251de9a637a5934ae6cd19a91fe99aa763b24c677329a8b8f28224a0e8c5ab8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d251de9a637a5934ae6cd19a91fe99aa763b24c677329a8b8f28224a0e8c5ab8"
    sha256 cellar: :any_skip_relocation, sonoma:        "be23696629cf433910d33fb5d903cffd6ab4cf33cca1f667d25751477f30d682"
    sha256 cellar: :any_skip_relocation, ventura:       "be23696629cf433910d33fb5d903cffd6ab4cf33cca1f667d25751477f30d682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff549be87e4855a893c6f3e20a9a2e939ccfc0aff6f7d948f39af5d26a8a663"
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
