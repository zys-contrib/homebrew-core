class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.45.tar.gz"
  sha256 "831e73649074979847cbd46c78081a8552bd75cdf65e259b426a3247e532b686"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3cfce7f2f4e374b4e9c3fbfc9b6d246bf982f585e937ae11d731d8d82f64aab"
    sha256 cellar: :any,                 arm64_sonoma:  "66cce38f5bea3f914d406f041df776bd4da0767e49dc5b782ff7d3b9500cabe9"
    sha256 cellar: :any,                 arm64_ventura: "96bce62f9a32ef7731dfdcaba51439f9599cff133c1b4428fbeebd23cd2efde2"
    sha256 cellar: :any,                 sonoma:        "0e45eeee973f61af1055c2b3330967dfd1f0db27400dbdd934794b42124d8e5d"
    sha256 cellar: :any,                 ventura:       "ed28a6da130eb9de8103cc8fc6024218eba01c3aead62a97b23921bf83d986a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "951f6b5df6a86b76c081e86aa4b8aa11153d4e5464df43213aac673d0b08c2f0"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
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
