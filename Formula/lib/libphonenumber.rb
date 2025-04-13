class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.2.tar.gz"
  sha256 "ccc54c3ff073f6f9be3260d0e93a17ab6e98be6906a15625a614b41de0d1693b"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f84b51c8e9260d0397989e48613b5dbbbf21bd9edfa79d0fec971c3fc54886d"
    sha256 cellar: :any,                 arm64_sonoma:  "d473644ea8040b162a3f3d2c796b4d765305ac05510657385febb745e15afd86"
    sha256 cellar: :any,                 arm64_ventura: "efb516309c50823a36ee5af2c388d5b0f859c0e5d5a7a40b4304d7e307f65411"
    sha256 cellar: :any,                 sonoma:        "a7f2ef8c108977f7aa3ab790a376b8d51721e168a18714a36ceca9e1dc3cd0f2"
    sha256 cellar: :any,                 ventura:       "7bc30ad493aa9c5281ae0ff6ce3be685f020ff7414b858a62886fc7fcef2532c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e80455956b99a9a414d6e85fd6b4597464fab92d9d8d4670cac178ee690c89b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "689f2fdef7d4ff1b919132a1b0098b25f007b11cbb0f51fef00c5d27921d3aaf"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@77"
  depends_on "protobuf"

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        std::string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES CXX)
      find_package(Boost COMPONENTS date_time system thread)
      find_package(libphonenumber CONFIG REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test libphonenumber::phonenumber-shared)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
