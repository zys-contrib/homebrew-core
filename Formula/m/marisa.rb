class Marisa < Formula
  desc "Matching Algorithm with Recursively Implemented StorAge"
  homepage "https://github.com/s-yata/marisa-trie"
  url "https://github.com/s-yata/marisa-trie/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "a3057d0c2da0a9a57f43eb8e07b73715bc5ff053467ee8349844d01da91b5efb"
  license any_of: ["BSD-2-Clause", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0bedacd84d336fe4bb03ba64d12c4b9558342bdc885ed1a730cc6c085cdac419"
    sha256 cellar: :any,                 arm64_sonoma:  "795ef8dde700a58b25068458ee84b339203647fdf847f65d9ec315f319569099"
    sha256 cellar: :any,                 arm64_ventura: "a2411485b60b2f253d201eb1499a94561a79d027742063e90e610d9ad0aa24b9"
    sha256 cellar: :any,                 sonoma:        "7b2008113fb52501f543358aa694c0050fba22e722d4fe2283d8515f39046025"
    sha256 cellar: :any,                 ventura:       "ae6b75381f71824e572676ee4a85f8164b306a08d8280ce729d21f36a2711f89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7ead9e59cdf466bf7908110f309200ae4e4f47fd4fd7bc6fd933924b072fa79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e15098e332fd27b0948bbdbb2fa592205f01521413605557085bcef124e124f9"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                     "-DBUILD_SHARED_LIBS=ON",
                     "-DCMAKE_INSTALL_RPATH=#{rpath}",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <cstdlib>
      #include <cstring>
      #include <ctime>
      #include <string>
      #include <iostream>
      #include <vector>

      #include <marisa.h>

      int main(void)
      {
        int x = 100, y = 200;
        marisa::swap(x, y);
        std::cout << x << "," << y << std::endl;
      }
    CPP

    system ENV.cxx, "-std=c++17", "./test.cc", "-o", "test"
    assert_equal "200,100", shell_output("./test").strip
  end
end
