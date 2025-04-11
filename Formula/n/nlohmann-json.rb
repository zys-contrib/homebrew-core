class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://json.nlohmann.me/"
  url "https://github.com/nlohmann/json/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "4b92eb0c06d10683f7447ce9406cb97cd4b453be18d7279320f7b2f025c10187"
  license "MIT"
  head "https://github.com/nlohmann/json.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3ebd5da2b7596028e92c6a82226aaa026a84fcca8a85db96b064b70e5426e810"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DJSON_BuildTests=OFF", "-DJSON_MultipleHeaders=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <iostream>
      #include <nlohmann/json.hpp>

      using nlohmann::json;

      int main() {
        json j = {
          {"pi", 3.141},
          {"name", "Niels"},
          {"list", {1, 0, 2}},
          {"object", {
            {"happy", true},
            {"nothing", nullptr}
          }}
        };
        std::cout << j << std::endl;
      }
    CPP

    system ENV.cxx, "test.cc", "-I#{include}", "-std=c++11", "-o", "test"
    std_output = <<~JSON
      {"list":[1,0,2],"name":"Niels","object":{"happy":true,"nothing":null},"pi":3.141}
    JSON
    assert_match std_output, shell_output("./test")
  end
end
