class Xeyes < Formula
  desc "Follow the mouse X demo using the X SHAPE extension"
  homepage "https://gitlab.freedesktop.org/xorg/app/xeyes"
  url "https://www.x.org/archive/individual/app/xeyes-1.3.0.tar.xz"
  sha256 "0950c600bf33447e169a539ee6655ef9f36d6cebf2c1be67f7ab55dacb753023"
  license "X11"

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxi"
  depends_on "libxmu"
  depends_on "libxrender"
  depends_on "libxt"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/xeyes -display :100 2>&1", 1)
    assert_match "Error: Can't open display:", output
  end
end
