class Ibex < Formula
  desc "C++ library for constraint processing over real numbers"
  homepage "https://ibex-team.github.io/ibex-lib/"
  url "https://github.com/ibex-team/ibex-lib/archive/refs/tags/ibex-2.9.0.tar.gz"
  sha256 "8d16ac2dfbc6de0353a12b7008d1d566bda52178f247d8461be02063972311a6"
  license "LGPL-3.0-only"
  head "https://github.com/ibex-team/ibex-lib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^ibex[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma:       "05e8146b72de3a2d65cab6bafa5d24b58b95901c4d44ce609b4561773ada2cd5"
    sha256 cellar: :any_skip_relocation, ventura:      "eea592d2c1c13bde0a000ca8705cabce4e11aeabb76a30dc8baf09931b9a22dd"
    sha256 cellar: :any_skip_relocation, monterey:     "5fe0810e9f6ef9b72c7d1e9ceba7b6b9c37410dd93f9801ac37e9738ec245005"
    sha256 cellar: :any_skip_relocation, big_sur:      "dbe9f4d68e4a406bd4926d6c821887e32af2d323f1d7ecd9a729ee0957c3e120"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1b64c5e784e7585d8a70179625a1a10a9b1c6926bd224c3d165abaed3db66c78"
  end

  depends_on "bison" => :build
  depends_on "cmake" => [:build, :test]
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "zlib"

  # Workaround for Intel macOS processor detection
  # Issue ref: https://github.com/ibex-team/ibex-lib/issues/567
  patch :DATA

  def install
    rpaths = [loader_path, rpath, rpath(target: lib/"ibex/3rd")]

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    *std_cmake_args.reject { |s| s["CMAKE_INSTALL_LIBDIR"] }

    # Workaround for Intel macOS build error: no member named '__fpcr' in 'fenv_t'
    # Issue ref: https://github.com/ibex-team/ibex-lib/issues/567
    if OS.mac? && Hardware::CPU.intel?
      inreplace "build/interval_lib_wrapper/gaol/gaol-4.2.3alpha0/gaol/gaol_fpu_fenv.h",
                "#if __APPLE__\n#   define CTRLWORD(v) (v).__fpcr",
                "#if __APPLE__\n#   define CTRLWORD(v) (v).__control"
    end

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install %w[examples benchs/solver]
    (pkgshare/"examples/symb01.txt").write <<~EOS
      function f(x)
        return ((2*x,-x);(-x,3*x));
      end
    EOS
  end

  test do
    system "cmake", "-S", pkgshare/"examples", "-B", ".", "-DCMAKE_BUILD_RPATH=#{lib};#{lib}/ibex/3rd"
    system "cmake", "--build", "."
    (1..8).each { |n| system "./lab#{n}" }
    (1..3).each { |n| system "./slam#{n}" }
  end
end

__END__
diff --git a/interval_lib_wrapper/gaol/3rd/mathlib-2.1.1/CMakeLists.txt b/interval_lib_wrapper/gaol/3rd/mathlib-2.1.1/CMakeLists.txt
index 65b5ea8b..24a2e5b9 100644
--- a/interval_lib_wrapper/gaol/3rd/mathlib-2.1.1/CMakeLists.txt
+++ b/interval_lib_wrapper/gaol/3rd/mathlib-2.1.1/CMakeLists.txt
@@ -43,7 +43,7 @@ elseif (CMAKE_SYSTEM MATCHES "CYGWIN" AND CMAKE_SYSTEM_PROCESSOR MATCHES "i.86")
 elseif (CMAKE_SYSTEM MATCHES "Darwin")
   if (CMAKE_SYSTEM_PROCESSOR MATCHES "arm64")
     set (MATHLIB_AARCH64 ON)
-  elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "i.86")
+  elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "i.86|86_64")
     set (MATHLIB_I86_MACOSX ON)
     set (IX86_CPU ON)
   else ()
