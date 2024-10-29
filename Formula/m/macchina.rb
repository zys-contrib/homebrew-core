class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/refs/tags/v6.3.1.tar.gz"
  sha256 "385bccc02f67c9ed6b9a483dbebdec901eb4beb82b15bb7969ee36028c19e475"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8518dfc18c21b5fdc170e90c706da7c4950bebb963ccdc443beacf203555f0be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77c46ca096fe6424436a8aa434eb8c6f94d6ff1dec8fe97b43d7eb87b0124b2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc40c3e570767d3180e29f6a574ef4f8929ee1ec440d6f1b3c5d591bf4035333"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a810be83019b6be80790bfb3d8ae2dbf51632e6a178e2d98f2ea15499ebbb1e"
    sha256 cellar: :any_skip_relocation, ventura:       "3fadb3b2847877402d54d5bcc48c826ba5cb142516f760f37a9f7e61c7ea15e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fdd9f4a20ff3cdeb7f8edff6c5679dd8b34f03d38ea360277cdeced9c9ddad7"
  end

  depends_on "rust" => :build

  # In order to update the dependent resources, check the link below
  # https://github.com/Macchina-CLI/macchina/tree/main/vendor
  # and find commit ids for the submodules, download tarball and update checksum.
  resource "ansi-to-tui" do
    url "https://github.com/Macchina-CLI/ansi-to-tui/archive/950d68067ed8c7f74469eb2fd996e04e1b931481.tar.gz"
    sha256 "e5f7b361dbc8400355ae637c4b66bcc28964e31bf634d6aa38684c510b38460e"
  end

  resource "color-to-tui" do
    url "https://github.com/Macchina-CLI/color-to-tui/archive/9a1b684d92cc64994889e100575e38316a68670b.tar.gz"
    sha256 "c30ec8f9314afd401c86c7b920864a6974557e72ad21059d3420db2dcffd02cb"
  end

  def install
    (buildpath/"vendor/ansi-to-tui").install resource("ansi-to-tui")
    (buildpath/"vendor/color-to-tui").install resource("color-to-tui")

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "We've collected a total of 19 readouts", shell_output("#{bin}/macchina --doctor")
  end
end
