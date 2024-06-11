class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https://scnlib.dev"
  url "https://github.com/eliaskosunen/scnlib/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "4435489aeaf4cdb8f81d0c48c4185e8436d80c57cff3e6cc7d1decd236f62fa6"
  license "Apache-2.0"
  head "https://github.com/eliaskosunen/scnlib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "84fdc89418240153c532c8b0f6657a1ceabb3b7fc636fd22b8e7471262367fe5"
    sha256 cellar: :any, arm64_ventura:  "0d88733c986a3df9d1bc26c3b768d3ede036dd0be3082e0ccc096c2679f3dd09"
    sha256 cellar: :any, arm64_monterey: "c5c3977d2289c4c19cff1e12f8b51bc361d147de8f2de959fd7635037d308188"
    sha256 cellar: :any, sonoma:         "4b5731760a71c16e1940ddc8062987604f3286e267ac3b3ff74cc6b02b4560d5"
    sha256 cellar: :any, ventura:        "b0c4cf802d7ba11c84d5d5ece50840393d4c56cc6817f34b41a475803edbe822"
    sha256 cellar: :any, monterey:       "ca75f67a9cf3e6654bfe78db00ea33bed3121b0ed3c574aa90778e956e9a2f87"
  end

  depends_on "cmake" => :build
  depends_on "simdutf"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DSCN_TESTS=OFF
      -DSCN_DOCS=OFF
      -DSCN_EXAMPLES=OFF
      -DSCN_BENCHMARKS=OFF
      -DSCN_BENCHMARKS_BUILDTIME=OFF
      -DSCN_BENCHMARKS_BINARYSIZE=OFF
      -DSCN_USE_EXTERNAL_SIMDUTF=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <scn/scan.h>
      #include <cstdlib>
      #include <string>

      int main()
      {
        constexpr int expected = 123456;
        auto [result] = scn::scan<int>(std::to_string(expected), "{}")->values();
        return result == expected ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lscn"
    system "./test"
  end
end
