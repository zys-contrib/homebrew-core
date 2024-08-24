class Cling < Formula
  desc "C++ interpreter"
  homepage "https://root.cern/cling/"
  url "https://github.com/root-project/cling/archive/refs/tags/v1.0.tar.gz"
  sha256 "93252c72bae2a660d9e2c718af18b767a09928078a854b2fcd77f28cc9fa71ae"
  license all_of: [
    { any_of: ["LGPL-2.1-only", "NCSA"] },
    { "Apache-2.0" => { with: "LLVM-exception" } }, # llvm
  ]

  bottle do
    sha256               arm64_monterey: "ae9ec74f889a58e57f00394e3b46dd1793d975ce7dc5907c71e2e15853610a62"
    sha256 cellar: :any, arm64_big_sur:  "82134eeea0ba90008355120b137908d828011e302b62ec97de10b152777d9651"
    sha256               monterey:       "90f4150c5bcc027fe76db2f53948eb31e757124da337639303eee2ac768c8999"
    sha256 cellar: :any, big_sur:        "e894d9476bc9ed0edb1ca8d3ca1d9fa6cefc8fc50befc93f1d1c25d1f1bee721"
    sha256 cellar: :any, catalina:       "fd178b38640189a9b096d9c98fe3b1dedc934a504ddc0d3dc1c6bbfea144f09f"
    sha256 cellar: :any, mojave:         "5135fc901ba316ca0e02f5598af21cd42a264994111252964f239b2576c7829b"
    sha256               x86_64_linux:   "315073c45b0684a970493476b9c8476ddf90eb7d69bd5326efdf97b79ec55e25"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "llvm" do
    url "https://github.com/root-project/llvm-project/archive/refs/tags/cling-llvm13-20240614-01.tar.gz"
    sha256 "c8afe609e9319009adf4e0fcb5021b663250ffbac1212c15058effb9ae6739d8"
  end

  def install
    # Skip modification of CLING_OSX_SYSROOT to the unversioned SDK path
    # Related: https://github.com/Homebrew/homebrew-core/issues/135714
    # Related: https://github.com/root-project/cling/issues/457
    inreplace "lib/Interpreter/CMakeLists.txt", '"MacOSX[.0-9]+\.sdk"', '"SKIP"'

    (buildpath/"llvm").install resource("llvm")

    system "cmake", "-S", "llvm/llvm", "-B", "build",
                    "-DCLING_CXX_PATH=clang++",
                    "-DLLVM_BUILD_TOOLS=OFF",
                    "-DLLVM_ENABLE_PROJECTS=clang",
                    "-DLLVM_EXTERNAL_CLING_SOURCE_DIR=#{buildpath}",
                    "-DLLVM_EXTERNAL_PROJECTS=cling",
                    "-DLLVM_TARGETS_TO_BUILD=host;NVPTX",
                    *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # We use an exec script as a symlink causes issues finding headers
    bin.write_exec_script libexec/"bin/cling"
  end

  test do
    test = <<~EOS
      '#include <stdio.h>' 'printf("Hello!")'
    EOS
    assert_equal "Hello!(int) 6", shell_output("#{bin}/cling #{test}").chomp
  end
end
