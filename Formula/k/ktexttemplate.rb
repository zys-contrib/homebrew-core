class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/frameworks/ktexttemplate/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.14/ktexttemplate-6.14.0.tar.xz"
  sha256 "65a908aa573e40cf9884a9d42a4b8d5574baf2f402a19764cda2cccde27c897a"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "655ad3df02220fc7317d9d71559e5cff0880eced7fc0a62654503b591d048702"
    sha256 arm64_ventura: "d055359a679dd99aa0781fc7b7b210df700fe83918b3cfb83aa04206a356029c"
    sha256 sonoma:        "c03f5a056c61739e301b10c129e2d9a90ce32ed0a5c92d79d35262ce4cf6b77f"
    sha256 ventura:       "153e03a6b14dd347a0f117731ae3c884a7111b5410bc158d20cb72b30db021f6"
    sha256 x86_64_linux:  "30b855d90cc6d84315b665cffcd9b1e01a05e89cc177b57f1c139039ca290372"
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
