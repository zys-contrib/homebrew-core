class Iowow < Formula
  desc "C utility library and persistent key/value storage engine"
  homepage "https://iowow.softmotions.com"
  url "https://github.com/Softmotions/iowow/archive/refs/tags/v1.4.18.tar.gz"
  sha256 "ef4ee56dd77ce326fff25b6f41e7d78303322cca3f11cf5683ce9abfda34faf9"
  license "MIT"
  head "https://github.com/Softmotions/iowow.git", branch: "master"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace "src/kv/examples/example1.c", "#include \"iwkv.h\"", "#include <iowow/iwkv.h>"
    (pkgshare/"examples").install "src/kv/examples/example1.c"
  end

  test do
    system ENV.cc, pkgshare/"examples/example1.c", "-I#{include}", "-L#{lib}", "-liowow", "-o", "example1"
    assert_match "put: foo => bar\nget: foo => bar\n", shell_output("./example1")
  end
end
