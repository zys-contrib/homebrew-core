class Xwininfo < Formula
  desc "Print information about windows on an X server"
  homepage "https://gitlab.freedesktop.org/xorg/app/xwininfo"
  url "https://www.x.org/archive/individual/app/xwininfo-1.1.6.tar.xz"
  sha256 "3518897c17448df9ba99ad6d9bb1ca0f17bc0ed7c0fd61281b34ceed29a9253f"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxcb"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/xwininfo -display :100 2>&1", 1)
    assert_match "xwininfo: error: unable to open display", output
  end
end
