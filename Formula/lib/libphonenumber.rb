class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.45.tar.gz"
  sha256 "831e73649074979847cbd46c78081a8552bd75cdf65e259b426a3247e532b686"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1cded69d8b26ed72680795d9545eb6ef394d530ce4f9a99cf7b0ef7ac0b62bd6"
    sha256 cellar: :any,                 arm64_ventura:  "1217af1b0028083b6ca421da275d4a69a861b85cdfdcd4472049d643b507ff72"
    sha256 cellar: :any,                 arm64_monterey: "b15d96a13f6c8dc4bfbd83fcdb0076355afcc6a37c436b6312141b77de36633e"
    sha256 cellar: :any,                 sonoma:         "aea19f85f6c69e34bf4b23d18628a871e0ef9d48af3c80efebdc337bb22dd5d7"
    sha256 cellar: :any,                 ventura:        "0bccd91df43d03a37c6eeb6c427d6f4eccac0fa6e3d7d488b202850c049e387a"
    sha256 cellar: :any,                 monterey:       "4f8c1ab7958dead62352c632d645276315723852ac057053ef899eadc90c716f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e90cf9a0a45748ab42d55fe5f0170bb2b3abbdb148efa82e08c57e5f7ed53c"
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
