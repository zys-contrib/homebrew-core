class Libultrahdr < Formula
  desc "Reference codec for the Ultra HDR format"
  homepage "https://developer.android.com/media/platform/hdr-image-format"
  url "https://github.com/google/libultrahdr/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "d57ec6186116bd3ab140b3ef1baa7077f91ad2e10539d8820fc641aee0417a2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f74e0cb7b904bfbf1bf949e0354a89bb28ffc76824f7bb612d76758f6d5a67c2"
    sha256 cellar: :any,                 arm64_sonoma:  "c2850201ee80d9eaf326a417cc3d7e2a33503c8c1956057e772713ff2d1afbc5"
    sha256 cellar: :any,                 arm64_ventura: "09fbfccb0ff2373e1ba0c07f2445c6ca4c75d2d9148a5de09b471b2094bfaa27"
    sha256 cellar: :any,                 sonoma:        "d4ea563be110bda70feb1489f4f4defadc3d856742d78c75a4c4da45b99fb008"
    sha256 cellar: :any,                 ventura:       "bba3657ad279753243ff8feb518836f9f0117d4976b1e59ce1087cbf8b021907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "853ae42d73cddb32e68911498a9b5ca8822f944274b35c7a98ba2ebf412edcb9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "jpeg-turbo"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ultrahdr_api.h>
      #include <iostream>

      int main() {
        std::cout << "UltraHDR Library Version: " << UHDR_LIB_VERSION_STR << std::endl;

        uhdr_codec_private_t* encoder = uhdr_create_encoder();
        uhdr_release_encoder(encoder);

        return 0;
      }
    CPP

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libuhdr").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", "-o", "test", *pkg_config_cflags
    assert_match "UltraHDR Library Version: #{version}", shell_output("./test")
  end
end
