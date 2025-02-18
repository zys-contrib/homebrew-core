class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.20.0.tar.gz"
  sha256 "df3df6b94bb72f4105a542246e02800db05cd6877088b0567c6169b94be5fea5"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "a51687d5f93a9f801b12ed1202ed208cec649ded4512f4fb0bb5eb65c1ad67a7"
    sha256 arm64_sonoma:  "4df77290ff1a5cdbe886a8f520562e95e63b18f36db2d228e849ab04d095543d"
    sha256 arm64_ventura: "7ae38a16356c5c03e8e729e634bba751f50dbcbcf51c9f6835f765f6064f8cca"
    sha256 sonoma:        "992c66834fb96b6948012c27fe2fb79039304a83701385b2e2eec65655d4ea16"
    sha256 ventura:       "34a3b070a3ccc27ead9150893c99a6d01f7b010e72241bcaf3ec91a8f1693ce4"
    sha256 x86_64_linux:  "6114e2da3f0f8a7bd2152f295a09bd2b8b5145ae40c98b6d1a09474af380bcb8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}/re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
