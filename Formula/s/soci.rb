class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-4.1.1/soci-4.1.1.zip"
  sha256 "b59bc01ec20fd9776cdb071f600acbe66b5a3f3350561abb97f5707649921d9c"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/soci[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_sequoia:  "6153858f4806accd079ba652dc3a1817a9ea95ba66b477ab15f548ec35e628f8"
    sha256 arm64_sonoma:   "b446260ca150f3d1451b8a44725d8532e4fe5157ac3e8040c008c07cff01b5e4"
    sha256 arm64_ventura:  "389f70f8884a86e67b2d9dde6d50796765d9360c2c3b31cc259ce32b8a87cd4e"
    sha256 arm64_monterey: "3071048f1067589c98521c479ad6ceeb317b70231072b227d67a7fc41bd81f27"
    sha256 arm64_big_sur:  "652d8306f60195b5689d236e5f4b876e0595480c97657c20f6ade9a49919f48b"
    sha256 sonoma:         "8e204b4cc8711785713a0b285c68b03894f602491c0beff38b45319f54a77982"
    sha256 ventura:        "d09c55a20635a29819cfda84d528f9616cf05d184efdc01949c36fb0327d9624"
    sha256 monterey:       "09ea83bf0e12deff7e63da0f41f1c16573f6eb017336c907648bec515430e0f1"
    sha256 big_sur:        "6e2001b1bf50eb5c6d913f61abcfb9074ac4a8dba810cc7f80546ca1157b5311"
    sha256 catalina:       "0ce9776bb40a4b6d3dc6d1ea62885a952e32c868fff1305b8e7f33a1e09689f2"
    sha256 arm64_linux:    "649b829aa0b5c30e5f6588ed7cd1a865f51ca70fe10bfd4a56917b9bc6b6520f"
    sha256 x86_64_linux:   "9a6461d6ec0bc9a1306f59a8a80c5c750f46b6bf13691f0e89b94c69399c0853"
  end

  depends_on "cmake" => :build
  depends_on "sqlite"

  def install
    args = %W[
      -DCMAKE_CXX_STANDARD=14
      -DSOCI_TESTS=OFF
      -DWITH_SQLITE3=ON
      -DWITH_BOOST=OFF
      -DWITH_MYSQL=OFF
      -DWITH_ODBC=OFF
      -DWITH_ORACLE=OFF
      -DWITH_POSTGRESQL=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<~CPP
      #include "soci/soci.h"
      #include "soci/empty/soci-empty.h"
      #include <string>

      using namespace soci;
      std::string connectString = "";
      backend_factory const &backEnd = *soci::factory_empty();

      int main(int argc, char* argv[])
      {
        soci::session sql(backEnd, connectString);
      }
    CPP
    system ENV.cxx, "-o", "test", "test.cxx", "-std=c++14", "-L#{lib}", "-lsoci_core", "-lsoci_empty"
    system "./test"
  end
end
