class Qwt < Formula
  desc "Qt Widgets for Technical Applications"
  homepage "https://qwt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.3.0/qwt-6.3.0.tar.bz2"
  sha256 "dcb085896c28aaec5518cbc08c0ee2b4e60ada7ac929d82639f6189851a6129a"
  license "LGPL-2.1-only" => { with: "Qwt-exception-1.0" }

  livecheck do
    url :stable
    regex(%r{url=.*?/qwt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6adb7582cb3f3668fc541f8d087ea1941e1a875ef5d492f74a98c142655236bf"
    sha256 cellar: :any,                 arm64_ventura:  "a9287c7fd09ae45bd5afc94788679c647b0f0d8b06c2150a8bb32ff19ccc6cb5"
    sha256 cellar: :any,                 arm64_monterey: "193e2f4e05debf6af85ff273f263f625687855c1608a3273c967aa2923a6c5f6"
    sha256 cellar: :any,                 sonoma:         "c0e5af00c8bd0937cc15c26ab5882805a523701688b39dfe9a4ae4c00ac79463"
    sha256 cellar: :any,                 ventura:        "3123515f8b0dc54033fd148442dc8cc92b6d490209c3f474ff29db8abd794bed"
    sha256 cellar: :any,                 monterey:       "b37d96c837d93dc53dcf9b97592a7f953651acae660b388e8800cffafb9bdcf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84711477f549b6b42ad1ad87bf333e94559836ad3637765c87fb3117f153325c"
  end

  depends_on "qt"

  # Apply Fedora patch to fix pkgconfig file.
  # Issue ref: https://sourceforge.net/p/qwt/bugs/353/
  patch do
    url "https://src.fedoraproject.org/rpms/qwt/raw/ea40e765e46413ae865a00f606688ea05e378e8a/f/qwt-pkgconfig.patch"
    sha256 "7ceb1153ba1d8da4dd61f343023fe742a304fba9f7ff8737c0e62f7dcb0e2bc2"
  end

  def install
    inreplace "qwtconfig.pri" do |s|
      s.gsub!(/^(\s*QWT_INSTALL_PREFIX\s*=).*$/, "\\1 #{prefix}")
      s.gsub! "= $${QWT_INSTALL_PREFIX}/doc", "= #{doc}"
      s.gsub! "= $${QWT_INSTALL_PREFIX}/plugins/designer", "= $${QWT_INSTALL_PREFIX}/share/qt/plugins/designer"
      s.gsub! "= $${QWT_INSTALL_PREFIX}/features", "= $${QWT_INSTALL_PREFIX}/share/qt/mkspecs/features"
    end

    os = OS.mac? ? "macx" : OS.kernel_name.downcase
    compiler = ENV.compiler.to_s.match?("clang") ? "clang" : "g++"

    system "qmake", "-config", "release", "-spec", "#{os}-#{compiler}"
    system "make"
    system "make", "install"

    # Backwards compatibility symlinks. Remove in a future release
    odie "Remove backwards compatibility symlinks!" if version >= 7
    prefix.install_symlink share/"qt/mkspecs/features"
    (lib/"qt/plugins/designer").install_symlink share.glob("qt/plugins/designer/*")
  end

  test do
    (testpath/"test.pro").write <<~QMAKE
      CONFIG  += console qwt
      CONFIG  -= app_bundle
      SOURCES += test.cpp
      TARGET   = test
      TEMPLATE = app
    QMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <qwt_plot_curve.h>
      int main() {
        QwtPlotCurve *curve1 = new QwtPlotCurve("Curve 1");
        return (curve1 == NULL);
      }
    CPP

    ENV.delete "CPATH"
    ENV["LC_ALL"] = "en_US.UTF-8"

    system Formula["qt"].bin/"qmake", "test.pro"
    system "make"
    system "./test"
  end
end
