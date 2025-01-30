class Xlsclients < Formula
  desc "List client applications running on a display"
  homepage "https://gitlab.freedesktop.org/xorg/app/xlsclients"
  url "https://www.x.org/archive/individual/app/xlsclients-1.1.5.tar.xz"
  sha256 "68baee57e70250ac4a7759fb78221831f97d88bc8e51dcc2e64eb3f8ca56bae3"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "libxcb"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/xlsclients -display :100 2>&1", 1)
    assert_match "xlsclients:  unable to open display", output
  end
end
