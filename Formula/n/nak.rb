class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "e1324be886a0cae4b49d9079932e5c8c7d85554cf1e6e62e0c3cc97c537cc7eb"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4244f1dbd88d5d1a51e3fc1894ec62eff65e9d8c85cd4730efe66a591c4d12a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4244f1dbd88d5d1a51e3fc1894ec62eff65e9d8c85cd4730efe66a591c4d12a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4244f1dbd88d5d1a51e3fc1894ec62eff65e9d8c85cd4730efe66a591c4d12a"
    sha256 cellar: :any_skip_relocation, sonoma:        "16aa5c89b843725c89624702462c7e094ec0734a031b4df75d886c7962019dee"
    sha256 cellar: :any_skip_relocation, ventura:       "16aa5c89b843725c89624702462c7e094ec0734a031b4df75d886c7962019dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb0800ef7fb17bfc7200d5f08ef3036f4f5718377d0c921f5c2d9fcd9b6f6292"
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
