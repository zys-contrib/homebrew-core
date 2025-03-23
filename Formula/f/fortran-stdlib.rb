class FortranStdlib < Formula
  desc "Fortran Standard Library"
  homepage "https://stdlib.fortran-lang.org"
  url "https://github.com/fortran-lang/stdlib/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "07615b1fd0d9c78f04ec5a26234d091cb7e359933ba2caee311dcd6f58d87af0"
  license "MIT"

  depends_on "cmake" => [:build, :test]
  depends_on "fypp" => :build
  depends_on "gcc" # for gfortran

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/version/example_version.f90", testpath

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES Fortran)

      find_package(fortran_stdlib REQUIRED)

      add_executable(test example_version.f90)
      target_link_libraries(test PRIVATE fortran_stdlib::fortran_stdlib)
    CMAKE

    system "cmake", "-S", "."
    system "cmake", "--build", "."
    system "./test"
  end
end
