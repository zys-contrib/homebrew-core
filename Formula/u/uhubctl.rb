class Uhubctl < Formula
  desc "USB hub per-port power control"
  homepage "https://github.com/mvp/uhubctl"
  url "https://github.com/mvp/uhubctl/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "56ca15ddf96d39ab0bf8ee12d3daca13cea45af01bcd5a9732ffcc01664fdfa2"
  license "GPL-2.0-only"
  head "https://github.com/mvp/uhubctl.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "make"
    bin.install "uhubctl"
  end

  test do
    # test uhubctl -v:
    assert_match version.to_s, shell_output(bin/"uhubctl -v")

    # test for non-existent USB device:
    actual = shell_output(bin/"uhubctl -l 100-1.2.3.4.5 -a 0 -p 1 2>&1", 1)
    expected = /No compatible devices detected/
    assert_match expected, actual
  end
end
