class Xprop < Formula
  desc "Property displayer for X"
  homepage "https://gitlab.freedesktop.org/xorg/app/xprop"
  url "https://www.x.org/archive/individual/app/xprop-1.2.8.tar.xz"
  sha256 "d689e2adb7ef7b439f6469b51cda8a7daefc83243854c2a3b8f84d0f029d67ee"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "libx11"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/xprop -display :100 2>&1", 1)
    assert_match "xprop:  unable to open display", output
  end
end
