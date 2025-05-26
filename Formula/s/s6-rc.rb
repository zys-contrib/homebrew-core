class S6Rc < Formula
  desc "Process supervision suite"
  homepage "https://skarnet.org/software/s6-rc/"
  url "https://skarnet.org/software/s6-rc/s6-rc-0.5.6.0.tar.gz"
  sha256 "81277f6805e8d999ad295bf9140a909943b687ffcfb5aa3c4efd84b1a574586e"
  license "ISC"

  depends_on "pkgconf" => :build
  depends_on "execline"
  depends_on "s6"
  depends_on "skalibs"

  def install
    # Shared libraries are linux targets and not supported on macOS.
    args = %W[
      --disable-silent-rules
      --disable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{Formula["pkgconf"].opt_bin}/pkg-config
      --with-sysdeps=#{Formula["skalibs"].opt_lib}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"services/test").mkpath
    (testpath/"services/test/up").write <<~SHELL
      #!/bin/sh
      echo "test"
    SHELL
    (testpath/"services/test/type").write "oneshot"
    (testpath/"services/bundle/contents.d").mkpath
    (testpath/"services/bundle/type").write "bundle"
    touch testpath/"services/bundle/contents.d/test"
    system bin/"s6-rc-compile", testpath/"compiled", testpath/"services"
  end
end
