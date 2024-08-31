class Frozen < Formula
  desc "Header-only, constexpr alternative to gperf for C++14 users"
  homepage "https://github.com/serge-sans-paille/frozen"
  url "https://github.com/serge-sans-paille/frozen/archive/refs/tags/1.2.0.tar.gz"
  sha256 "ed8339c017d7c5fe019ac2c642477f435278f0dc643c1d69d3f3b1e95915e823"
  license "Apache-2.0"
  head "https://github.com/serge-sans-paille/frozen.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b3ca38fbf1e4b99e8f5b9d2b4549a7a51672a8d3be35bb4a918bcf89500aeb43"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/pixel_art.cpp", testpath

    system ENV.cxx, "pixel_art.cpp", "-o", "test", "-std=c++14"
    system "./test"
  end
end
