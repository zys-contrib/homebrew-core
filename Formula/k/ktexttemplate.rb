class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/frameworks/ktexttemplate/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.15/ktexttemplate-6.15.0.tar.xz"
  sha256 "5c652ebae5d32d1b84fa438ad94cc621621d31e0abcfef3b0a511a586d697a84"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "ef59740aa92c1579775fdcc04836fe979eda07145aac1557767a18f187b0bf02"
    sha256 arm64_ventura: "a77f2e54f701f0edb1f9ba10a01e496ca680605fbf34d0e279b5d944d133cea6"
    sha256 sonoma:        "a2e80acb4e2facfc78451ffd8aaef4439803477db57519d80986c35e03b30efb"
    sha256 ventura:       "0082012c54a68652ab1ed417a5853634d4b1e4170715d48743eb28b55e1eea43"
    sha256 x86_64_linux:  "010e0dcbd03bf87200e3a485d8ef23177dcfc017c7b4b0b0cc7e7888a1446b1a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => :build
  depends_on "qt"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    system "cmake", pkgshare/"examples/codegen", *std_cmake_args
    system "cmake", "--build", "."
  end
end
