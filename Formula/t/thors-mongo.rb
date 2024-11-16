class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "6.0.06",
      revision: "9ff64c7f7d52415a9f09d764078a9d2b29b06f16"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb9b17d9451ec02a0c9f9c5df245db42582385062964c1f29a4d6552242ffaf2"
    sha256 cellar: :any,                 arm64_sonoma:  "7601dfe7c27d029a8df9ecea35aad364d4decc216ecb61d594433795adce942c"
    sha256 cellar: :any,                 arm64_ventura: "afac27843d850a849ca27e69b95d0d573486fe14f54bb64ea3d605f59c004f28"
    sha256 cellar: :any,                 sonoma:        "8db835fe97f407d1ef595d83ed05ce27af564b01a10424d59b5adc7c3b285116"
    sha256 cellar: :any,                 ventura:       "cfb7d3613d06c37eca7d52e4fde25ebf99ab38d6efb068785410ddc22d697521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc5501bd71370763c82232beb8cc92edcc28217b260a4d10039b341dcfb763b5"
  end

  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    ENV["COV"] = "gcov"

    system "./brew/init"

    system "./configure", "--disable-vera",
                          "--prefix=#{prefix}",
                          "--disable-test-with-integration",
                          "--disable-test-with-mongo-query",
                          "--disable-Mongo-Service"

    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "ThorSerialize/JsonThor.h"
      #include "ThorSerialize/SerUtil.h"
      #include <sstream>
      #include <iostream>
      #include <string>

      struct HomeBrewBlock
      {
          std::string             key;
          int                     code;
      };
      ThorsAnvil_MakeTrait(HomeBrewBlock, key, code);

      int main()
      {
          using ThorsAnvil::Serialize::jsonImporter;
          using ThorsAnvil::Serialize::jsonExporter;

          std::stringstream   inputData(R"({"key":"XYZ","code":37373})");

          HomeBrewBlock    object;
          inputData >> jsonImporter(object);

          if (object.key != "XYZ" || object.code != 37373) {
              std::cerr << "Fail";
              return 1;
          }
          std::cerr << "OK";
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++20", "test.cpp", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lThorSerialize", "-lThorsLogging", "-ldl"
    system "./test"
  end
end
