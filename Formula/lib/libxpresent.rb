class Libxpresent < Formula
  desc "Xlib-based library for the X Present Extension"
  homepage "https://gitlab.freedesktop.org/xorg/lib/libxpresent"
  url "https://www.x.org/archive/individual/lib/libXpresent-1.0.1.tar.xz"
  sha256 "b964df9e5a066daa5e08d2dc82692c57ca27d00b8cc257e8e960c9f1cf26231b"
  license "MIT"

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxpresent.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "util-macros" => :build
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "libxrandr"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <X11/extensions/Xpresent.h>

      int main() {
        XPresentNotify notify;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
