class Packetry < Formula
  desc "Fast, intuitive USB 2.0 protocol analysis application for use with Cynthion"
  homepage "https://github.com/greatscottgadgets/packetry"
  url "https://github.com/greatscottgadgets/packetry/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "8d91ddc17883299f302752b12e11aa539c306304109d733c8863b7bc444c9629"
  license "BSD-3-Clause"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "graphene"
    depends_on "harfbuzz"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/packetry --version")

    # Expected result is panic because Cynthion is not connected via USB.
    assert_match "Testing", shell_output("#{bin}/packetry --test-cynthion", 101)
  end
end
