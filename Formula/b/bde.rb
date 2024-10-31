class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.16.1.0.tar.gz"
  sha256 "32bb1912b6c37b11ca86c87a7295adeca928ef816014926da089088e5a843d6d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "62983ce5639b46b9489403ccbf11468c34a1c6f7ae94059a27df903561b8cad1"
    sha256 cellar: :any,                 arm64_sonoma:  "171defd5302883ad5af86eed46c38547f5fd23e37c782341b9818ea1c73e876d"
    sha256 cellar: :any,                 arm64_ventura: "579723d1b3070b33a7ce734c606c2ac4c773d907442b95323c3f8619a9f2b561"
    sha256 cellar: :any,                 sonoma:        "af0fc982ce22e35239e1de3d645b008cdde31f0495bd9e021c40f061ce4121e2"
    sha256 cellar: :any,                 ventura:       "73b5fb36ed2c5410759ac52946631d210d90a8e27fadbdcb0adb209ab94587c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00bc4f3329b797923a1f3996fc3f61a5124136a54d41b793b2475ad207f38760"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.13" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.13.0.0.tar.gz"
    sha256 "d70ab85eb1a4325f3d569a6b7ea0f0a44a6143fd91905ab5fbaa5e1fed111a68"
  end

  def install
    (buildpath/"bde-tools").install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    rm_r buildpath/"thirdparty/pcre2"
    inreplace "project.cmake", "${listDir}/thirdparty/pcre2\n", ""
    inreplace "groups/bdl/group/bdl.dep", "pcre2", "libpcre2-posix"
    inreplace "groups/bdl/bdlpcre/bdlpcre_regex.h", "#include <pcre2/pcre2.h>", "#include <pcre2.h>"

    toolchain_file = "bde-tools/cmake/toolchains/#{OS.kernel_name.downcase}/default.cmake"
    args = %W[
      -DBUILD_BITNESS=64
      -DUFID=opt_exc_mt_64_shr
      -DCMAKE_MODULE_PATH=./bde-tools/cmake
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file}
      -DPYTHON_EXECUTABLE=#{which("python3.13")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # CMake install step does not conform to FHS
    lib.install Dir[bin/"so/64/*"]
    lib.install lib/"opt_exc_mt_shr/cmake"
  end

  test do
    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<~CPP
      #include <bsl_string.h>
      #include <bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end
