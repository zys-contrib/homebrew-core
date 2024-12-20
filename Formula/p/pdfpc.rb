class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "0083a958a2e9288a15c31aabb76b3eadf104672b4e815017f31ffa0d87db02ec"
  license "GPL-3.0-or-later"
  head "https://github.com/pdfpc/pdfpc.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "2a9add17232af69e9969cc6fa4a4c2546f032334ee2a5c82884ea91f1b8bd6d9"
    sha256 arm64_sonoma:   "37e68010fd59d6d822bc592edfefe7829e6308a3be011e04710e81289e45787a"
    sha256 arm64_ventura:  "fd6970c02ca367a6050696a949c2ccfc08cbb4cef034dbe189d57f66b2fc6dd3"
    sha256 arm64_monterey: "746f25f24ee4224d84988f30a3b146f54f11b1423a2baaea9d128b07f7459862"
    sha256 sonoma:         "6f694849557954ac891ca62a7cd3951e7fb370ecec600490bc26040dc01bd723"
    sha256 ventura:        "5609c58c83e0f2da72bbecb2279b63b53fcc05991cd2f0220fb2b6c248611bb2"
    sha256 monterey:       "34a795721a3934b8417c867c468d7d7fb5400486e0fc5e1f89aeabce60dc7ed4"
    sha256 x86_64_linux:   "e516f2299f19c3e6ab4f200e4fcef85508655fe7890331e741a7303f9bc1a528"
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "discount"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "libx11"
  depends_on "pango"
  depends_on "poppler"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "webkitgtk"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DMDVIEW=#{OS.linux?}", # Needs webkitgtk
                    "-DMOVIES=ON",
                    "-DREST=OFF",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Gtk-WARNING **: 00:25:01.545: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system bin/"pdfpc", "--version"
  end
end
