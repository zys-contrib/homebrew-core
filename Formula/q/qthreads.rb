class Qthreads < Formula
  desc "Lightweight locality-aware user-level threading runtime"
  homepage "https://www.sandia.gov/qthreads/"
  url "https://github.com/sandialabs/qthreads/archive/refs/tags/1.22.tar.gz"
  sha256 "76804e730145ee26f661c0fbe3f773f2886d96cb8a72ea79666f7714403d48ad"
  license "BSD-3-Clause"
  head "https://github.com/sandialabs/qthreads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "96285a04844a48e8d9fb1b42603028838283daa73d0f128b2f5693ae26b0034f"
    sha256 cellar: :any,                 arm64_sonoma:  "e4c8067e01b5b13796c266aadef6f0b87a55eb98074f491213b4278402a84eec"
    sha256 cellar: :any,                 arm64_ventura: "d6f302754331981d1eb27dc3171ac6d959abf587c8fa73f9bcf43314a1e9b979"
    sha256 cellar: :any,                 sonoma:        "350662c7facb3943957870c0769b1442c051f824512276c15ae1171eaf69d49d"
    sha256 cellar: :any,                 ventura:       "0e23710563e3ebdb83505cd7817dada31a3aafd2fa9460aace926dc022eefabb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1d37bb159cb706c38bf76372026532407eba1e1f93702147710c0d5ecffae32"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "userguide/examples"
    doc.install "userguide"
  end

  test do
    system ENV.cc, pkgshare/"examples/hello_world.c", "-o", "hello", "-I#{include}", "-L#{lib}", "-lqthread"
    assert_equal "Hello, world!", shell_output("./hello").chomp
  end
end
