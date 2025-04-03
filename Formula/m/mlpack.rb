class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-4.6.0.tar.gz"
  sha256 "8b90c18b25f94319c5969796e63fea96f3f85d9eff41323f12e9964706935632"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  head "https://github.com/mlpack/mlpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "14103e2ce794d0e8cda3bb85a4ca003bb15e696294865e788cd2f5bbab1f33c2"
    sha256 cellar: :any,                 arm64_sonoma:  "f08fb3c4bd5fecca6e3000d55d50930981abc3b18c990ba266199f85c466afaa"
    sha256 cellar: :any,                 arm64_ventura: "6d19da72724ba1093b67d027fb8fe78fc1432056331a8ad762b8064f20e47ae4"
    sha256 cellar: :any,                 sonoma:        "3d7638fd522a387521743fcee1baf6e5cbfaf0e64d594c16a96f04f75083a03e"
    sha256 cellar: :any,                 ventura:       "7bbd042a5ce26f803ed770587a64805486f84c1955ec6ab926634e6150148285"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51165e0db78be4b403f90ccbbd4448ef2f26541ce374635cda5e3065a69a65b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec3664885fb3cf60787a14f0a0b2492a4ffa18c90a6a95561e75bf506a18b119"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "armadillo"
  depends_on "cereal"
  depends_on "ensmallen"

  resource "stb_image" do
    url "https://raw.githubusercontent.com/nothings/stb/013ac3beddff3dbffafd5177e7972067cd2b5083/stb_image.h"
    version "2.30"
    sha256 "594c2fe35d49488b4382dbfaec8f98366defca819d916ac95becf3e75f4200b3"
  end

  resource "stb_image_write" do
    url "https://raw.githubusercontent.com/nothings/stb/1ee679ca2ef753a528db5ba6801e1067b40481b8/stb_image_write.h"
    version "1.16"
    sha256 "cbd5f0ad7a9cf4468affb36354a1d2338034f2c12473cf1a8e32053cb6914a05"
  end

  def install
    resources.each do |r|
      r.stage do
        (include/"stb").install "#{r.name}.h"
      end
    end

    args = %W[
      -DDEBUG=OFF
      -DPROFILE=OFF
      -DBUILD_TESTS=OFF
      -DUSE_OPENMP=OFF
      -DARMADILLO_INCLUDE_DIR=#{Formula["armadillo"].opt_include}
      -DENSMALLEN_INCLUDE_DIR=#{Formula["ensmallen"].opt_include}
      -DARMADILLO_LIBRARY=#{Formula["armadillo"].opt_lib/shared_library("libarmadillo")}
      -DSTB_IMAGE_INCLUDE_DIR=#{include}/stb
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install Dir["doc/*"]
    (pkgshare/"tests").install "src/mlpack/tests/data" # Includes test data.
  end

  test do
    system bin/"mlpack_knn",
      "-r", "#{pkgshare}/tests/data/GroupLensSmall.csv",
      "-n", "neighbors.csv",
      "-d", "distances.csv",
      "-k", "5", "-v"

    (testpath/"test.cpp").write <<~CPP
      #include <mlpack/core.hpp>

      using namespace mlpack;

      int main(int argc, char** argv) {
        Log::Debug << "Compiled with debugging symbols." << std::endl;
        Log::Info << "Some test informational output." << std::endl;
        Log::Warn << "A false alarm!" << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{Formula["armadillo"].opt_lib}",
                    "-larmadillo", "-L#{lib}", "-o", "test"
    system "./test", "--verbose"
  end
end
