class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.10.3/qxmpp-v1.10.3.tar.bz2"
  sha256 "d36e6828dee496df14b7c2d3eac6c125c50645b869725b4535ecba443cafaa21"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "a898808fd24fee088fc311c25de3624ee37144dacce4b05dcbfee5f62fc7da34"
    sha256 cellar: :any,                 arm64_ventura: "59b68c411095b53b446afbab1ef4297b7a87d92e77a9e72adff2e807bfad0244"
    sha256 cellar: :any,                 sonoma:        "6cf041d0c5d5c83880cf0512d8da6c4bf94d035b0eed19df0523e4faf205a1cd"
    sha256 cellar: :any,                 ventura:       "ae3eef6653afb55f2b5c96b1e54799cd2accac2c7b98ae63f20d8d41ac6b8770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1a18f73a630ee408ad80536478fa74f23e24abeb8f1243052319ad9e667e0b4"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      QT          += network
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lQXmppQt6
      QMAKE_RPATHDIR += #{lib}
    EOS

    (testpath/"test.cpp").write <<~CPP
      #include <QXmppQt6/QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    CPP

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end
