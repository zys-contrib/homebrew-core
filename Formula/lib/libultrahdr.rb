class Libultrahdr < Formula
  desc "Reference codec for the Ultra HDR format"
  homepage "https://developer.android.com/media/platform/hdr-image-format"
  url "https://github.com/google/libultrahdr/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "bf425e10a1a36507d47eb2711018e90effe11c76db8ecd4f10f4e1af9cb5288c"
  license "Apache-2.0"

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
