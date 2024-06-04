class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.38.tar.gz"
  sha256 "be552c23c321857630b6abc35aab64d75a8de6bc7a72443863213706dad74891"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "68c7b5bbb75d5159af2329cb1d6ef633d5a636915d7aacd1dee34ae9c97edd71"
    sha256 cellar: :any,                 arm64_ventura:  "069e3e79ba168d93c305770489cbdcb9b639d25856526b258d83edabf18be2c4"
    sha256 cellar: :any,                 arm64_monterey: "f5f1bd415695944ef648500135b3bcbe30362934298768b96c5b75a45294b579"
    sha256 cellar: :any,                 sonoma:         "3cc7c9cbf1ee86707476f9ff27d504c6f9ed12ac03e8585d83083872a761ed3a"
    sha256 cellar: :any,                 ventura:        "76ea7cdff42fa5c5aaba51c7a0f90dc46066444402603902d45deded404644c2"
    sha256 cellar: :any,                 monterey:       "df7c4b419f2fdfee4a022643ad8d5c64c858c02c2970a03d299c3a88e8a7c659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8faf4683bea1966f8e17a61b8cddc369e8a67a9bb02dd7055f7c3847bd2264cc"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                    "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].opt_include}",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
