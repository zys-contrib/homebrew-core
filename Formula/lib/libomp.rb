class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.2/openmp-20.1.2.src.tar.xz"
  sha256 "cb3abc0378d2beaaad000008b12273854f5f4ff3e1c8bc9f4017945592a52065"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8168a1da1ba2fdfca159fc501e40bdccf2dd6645a491fe7f6094d93308720b51"
    sha256 cellar: :any,                 arm64_sonoma:  "3951019b9f485c749e47b3aa428739a6108f8de336b6ce83ccdd28d3d0bf38e3"
    sha256 cellar: :any,                 arm64_ventura: "873bdae8c0c7b52562614a936a7e92eec5d1ff211140e6ef4adf9a84e544cc4d"
    sha256 cellar: :any,                 sonoma:        "edaa8b5568131f6f78c4994ce1d7fffdbf8b03f9f24eb83a7f3bbf7e79afefcd"
    sha256 cellar: :any,                 ventura:       "62a0297459dfc6d2afed5c96262dda587aee4f5ac01732e7d4b2d640c3f94505"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e165d1c341672f66474f7561162210afea7f27902b0c3c2be53ce604737e5254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "713a0c09054a13c1beb37e2efc84dc0dac048f01a5ffbab805b32a545f9b59c0"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.13"
  end

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.2/cmake-20.1.2.src.tar.xz"
    sha256 "8a48d5ff59a078b7a94395b34f7d5a769f435a3211886e2c8bf83aa2981631bc"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "cmake resource needs to be updated" if version != resource("cmake").version

    (buildpath/"src").install buildpath.children
    (buildpath/"cmake").install resource("cmake")

    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    args = ["-DLIBOMP_INSTALL_ALIASES=OFF"]
    args << "-DOPENMP_ENABLE_LIBOMPTARGET=OFF" if OS.linux?

    system "cmake", "-S", "src", "-B", "build/shared", *std_cmake_args, *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "src", "-B", "build/static",
                    "-DLIBOMP_ENABLE_SHARED=OFF",
                    *std_cmake_args, *args
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <omp.h>
      #include <array>
      int main (int argc, char** argv) {
        std::array<size_t,2> arr = {0,0};
        #pragma omp parallel num_threads(2)
        {
            size_t tid = omp_get_thread_num();
            arr.at(tid) = tid + 1;
        }
        if(arr.at(0) == 1 && arr.at(1) == 2)
            return 0;
        else
            return 1;
      }
    CPP
    system ENV.cxx, "-Werror", "-Xpreprocessor", "-fopenmp", "test.cpp", "-std=c++11",
                    "-I#{include}", "-L#{lib}", "-lomp", "-o", "test"
    system "./test"
  end
end
