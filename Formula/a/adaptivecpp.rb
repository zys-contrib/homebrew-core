class Adaptivecpp < Formula
  desc "SYCL and C++ standard parallelism for CPUs and GPUs"
  homepage "https://github.com/AdaptiveCpp/AdaptiveCpp"
  url "https://github.com/AdaptiveCpp/AdaptiveCpp/archive/refs/tags/v24.10.0.tar.gz"
  sha256 "3bcd94eee41adea3ccc58390498ec9fd30e1548af5330a319be8ce3e034a6a0b"
  license "BSD-2-Clause"
  head "https://github.com/AdaptiveCpp/AdaptiveCpp.git", branch: "develop"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "llvm"
  uses_from_macos "python"

  on_macos do
    depends_on "libomp"
  end

  def install
    libomp_root = Formula["libomp"].opt_prefix

    system "cmake", "-S", ".", "-B", "build", "-DOpenMP_ROOT=#{libomp_root}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    shim_references = [prefix/"etc/AdaptiveCpp/acpp-core.json"]
    inreplace shim_references, Superenv.shims_path/ENV.cxx, ENV.cxx

    # we add -I#{libomp_root}/include to default-omp-cxx-flags
    inreplace prefix/"etc/AdaptiveCpp/acpp-core.json",
      "\"default-omp-cxx-flags\" : \"", "\"default-omp-cxx-flags\" : \"-I#{libomp_root}/include "
  end

  test do
    system bin/"acpp", "--version"

    (testpath/"hellosycl.cpp").write <<~C
      #include <sycl/sycl.hpp>
      int main(){
          sycl::queue q{};
      }
    C
    system bin/"acpp", "hellosycl.cpp", "-o", "hello"
    system "./hello"
  end
end
