class Lsix < Formula
  desc "Shows thumbnails in terminal using sixel graphics"
  homepage "https://github.com/hackerb9/lsix"
  url "https://github.com/hackerb9/lsix/archive/refs/tags/1.9.tar.gz"
  sha256 "e1b33cf97b83c96d57de3c593656a11236df394d739a8aa755e9e97f74d8e960"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e85eb94ac6efc8a2a31093981b58d60d5eb0fb0845ab14c5afdc89a22f91c01c"
  end

  depends_on "bash"
  depends_on "imagemagick"

  def install
    bin.install "lsix"
  end

  test do
    output = shell_output "#{bin}/lsix 2>&1"
    assert_match "Error: Your terminal does not report having sixel graphics support.", output
  end
end
