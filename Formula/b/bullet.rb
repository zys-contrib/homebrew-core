class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/refs/tags/3.25.tar.gz"
  sha256 "c45afb6399e3f68036ddb641c6bf6f552bf332d5ab6be62f7e6c54eda05ceb77"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "70c2517b16906464fba68e8c3467d6440e483e550f649402339bddf1bcaa87dd"
    sha256 cellar: :any,                 arm64_ventura:  "6cb9f0e3435ac577cdae63a3593693da7a2e93110e92691f9b43ab35282bfa5a"
    sha256 cellar: :any,                 arm64_monterey: "84fe44bad0dc14eb49e1cd40c6ef1545c05186aca4a5a7e5e485fdabc3751fe5"
    sha256 cellar: :any,                 arm64_big_sur:  "c786c28169f4f65cfb8c6183453a468386ec9f58dbfa45420510ebd272be1ecd"
    sha256 cellar: :any,                 sonoma:         "329d917b1c71b47a29f24fdf341a0deb6ce89a3d84b9c6233bde1b37bc0f61bb"
    sha256 cellar: :any,                 ventura:        "4bfaa654682214a65629e2d09f36944857fc67162fde4bbb67e7bce7b6ff10b6"
    sha256 cellar: :any,                 monterey:       "50eed1d7cd3dedb6c64970b2a729e0128cb18f20477c106676e18d7539764fda"
    sha256 cellar: :any,                 big_sur:        "89803317a3b1ca72df1f1473efd8d99bcb857f47c2c3adccc7b4cb3ffc2fe406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3670bbfd66cfd61791baf1e268c42baab46191b1b8e11392d18d6f34c8b1875"
  end

  depends_on "cmake" => :build
  depends_on "numpy" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]

  def python3
    "python3.12"
  end

  def install
    # C++11 for nullptr usage in examples. Can remove when fixed upstream.
    # Issue ref: https://github.com/bulletphysics/bullet3/pull/4243
    ENV.cxx11 if OS.linux?

    common_args = %w[
      -DBT_USE_EGL=ON
      -DBUILD_UNIT_TESTS=OFF
      -DINSTALL_EXTRA_LIBS=ON
      -DBULLET2_MULTITHREADING=ON
    ] + std_cmake_args(find_framework: "FIRST")

    system "cmake", "-S", ".", "-B", "build_double",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{loader_path}",
                    "-DUSE_DOUBLE_PRECISION=ON",
                    *common_args
    system "cmake", "--build", "build_double"
    system "cmake", "--install", "build_double"
    (lib/"bullet/double").install lib.children

    system "cmake", "-S", ".", "-B", "build_static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *common_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    python_version = Language::Python.major_minor_version python3
    python_prefix = if OS.mac?
      Formula["python@#{python_version}"].opt_frameworks/"Python.framework/Versions/#{python_version}"
    else
      Formula["python@#{python_version}"].opt_prefix
    end
    prefix_site_packages = prefix/Language::Python.site_packages(python3)

    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{loader_path};#{rpath(source: prefix_site_packages)}",
                    "-DBUILD_PYBULLET=ON",
                    "-DBUILD_PYBULLET_NUMPY=ON",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DPYTHON_INCLUDE_DIR=#{python_prefix}/include/python#{python_version}",
                    "-DPYTHON_LIBRARY=#{python_prefix}/lib",
                    *common_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    # Install single-precision library symlinks into `lib/"bullet/single"` for consistency
    (lib/"bullet/single").install_symlink (lib.children - [lib/"bullet"])
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "LinearMath/btPolarDecomposition.h"
      int main() {
        btMatrix3x3 I = btMatrix3x3::getIdentity();
        btMatrix3x3 u, h;
        polarDecompose(I, u, h);
        return 0;
      }
    EOS

    cxx_lib = if OS.mac?
      "-lc++"
    else
      "-lstdc++"
    end

    # Test single-precision library
    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system "./test"

    # Test double-precision library
    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}/bullet/double",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system "./test"

    system python3, "-c", <<~EOS
      import pybullet
      pybullet.connect(pybullet.DIRECT)
      pybullet.setGravity(0, 0, -10)
      pybullet.disconnect()
    EOS
  end
end
