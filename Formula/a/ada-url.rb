class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "525890a87a002b1cc14c091800c53dcf4a24746dbfc5e3b8a9c80490daad9263"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "478d262d91cc68c6f9912c833c7a75a1d866da04a98eacf84289003dae80e2d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aea96e365e7a785199e7579c1beb18c009eb634a7fdc2b79821e7d1764a1ee5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "075ac46124ebf24c5a837ce7bf1c0fc5358758d31f48562e199e9d4f1ba5580b"
    sha256 cellar: :any_skip_relocation, sonoma:        "184fc1e9046c0c22f83498aee0ec945ee69d2ddf4039cc7683cba9135bd956a7"
    sha256 cellar: :any_skip_relocation, ventura:       "6e46ceeeae69b0d7fc278e5c295348329970503ea2578b826f233df7f10b8e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebccab8cce7cb929746d4a1e00976b514e25b3652cde89f167a199b1f709bffe"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++" if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    (testpath/"test.cpp").write <<~CPP
      #include "ada.h"
      #include <iostream>

      int main(int , char *[]) {
        auto url = ada::parse<ada::url_aggregator>("https://www.github.com/ada-url/ada");
        url->set_protocol("http");
        std::cout << url->get_protocol() << std::endl;
        return EXIT_SUCCESS;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++20",
           "-I#{include}", "-L#{lib}", "-lada", "-o", "test"
    assert_equal "http:", shell_output("./test").chomp
  end
end
