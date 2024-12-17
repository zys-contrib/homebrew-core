class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/refs/tags/v19.0.0.tar.gz"
  sha256 "83bae1f0e24dc44d9d85014d5cd0474df2dd03975680894ce3fafd6e97dffee2"
  license "MIT"
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia: "a47babd7741a825bbce356c14d356810c285ddbae7ee18dd0c3df827bf8347ba"
    sha256 cellar: :any,                 arm64_sonoma:  "ca7b252871d4c067737db812d14b3467500e16158b2989086a9df041b5236390"
    sha256 cellar: :any,                 arm64_ventura: "0d70fd91451260abc7c479759b93bee154123f1cdf5e0d8e725a6b6306bd8acb"
    sha256 cellar: :any,                 sonoma:        "a2573bcd16dbb7de7025c788374881d8dfdaa313f67032eb9c97b065303b401a"
    sha256 cellar: :any,                 ventura:       "73cb1225eecf3b0ef6d50e5599bec8f8592c256c3dcf4213df47582849ffcf7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53aacb6e8c1c2950cb98ff4dd9f634a9f1e0e95db56644816d8837776c79609"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "flatbuffers"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "lld"
  depends_on "llvm"
  depends_on "python@3.13"
  depends_on "wabt"

  on_macos do
    depends_on "openssl@3"
  end

  def python3
    "python3.13"
  end

  def install
    site_packages = prefix/Language::Python.site_packages(python3)
    rpaths = [rpath, rpath(source: site_packages/"halide")]
    args = [
      "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
      "-DHalide_INSTALL_PYTHONDIR=#{site_packages}/halide",
      "-DHalide_LLVM_SHARED_LIBS=ON",
      "-DHalide_USE_FETCHCONTENT=OFF",
      "-DWITH_TESTS=NO",
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")

    cp share/"doc/Halide_Python/tutorial-python/lesson_01_basics.py", testpath
    assert_match "Success!", shell_output("#{python3} lesson_01_basics.py")
  end
end
