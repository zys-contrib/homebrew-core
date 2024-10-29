class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "8483a427b70f0bfd89ff0fd5e05f9a622d9d8d84cce9cf8b390af7ee918a73f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "765abf4474d4cb68627df0bc428202918dc55cd1c68b39ba88f0303a3d418990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b720d3c8c9568455139815334ca4496932f9f3ec7330e44aa796377ec1fb1aba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c356c873aae2486bf6ba6720f810f5b0ec193a53dd3d6d7ff756777f4d4ba555"
    sha256 cellar: :any_skip_relocation, sonoma:        "de544a806f0982f2899ae4c2e944594a02a0c6212c3678037baed460a221ca96"
    sha256 cellar: :any_skip_relocation, ventura:       "f59ec7769b594b3b1991dcb05a4294f6d17da79fb53a76da03d2e308383e43d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a6d75144ef0177ae802f25d5345a52f6e7db2c81a465c30b6665f0e2f99b86"
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
