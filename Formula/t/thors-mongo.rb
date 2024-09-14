class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "3.5.15",
      revision: "751b5c3a2c55166143d2015021eafc7ab6e5c837"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7c29b9039e2a2e8774f4d1f1b3282c2f3e6f36013ff13b01656d5fde746190fd"
    sha256 cellar: :any,                 arm64_sonoma:  "e6506faa3dc0e401cc3c8bc4aeb5906bbb4b9531d81581270e8e1b3ed99953b8"
    sha256 cellar: :any,                 arm64_ventura: "7f25e60f3d0aabaa9a93f520e21d43441596f68f3f7e5d02c16623c310e4d86e"
    sha256 cellar: :any,                 sonoma:        "40ce2655758106e312999bd9545253502288ed8f07f070310773cac231b21e83"
    sha256 cellar: :any,                 ventura:       "126cbb2e2f5c4c1190c9880c5aa341d003bddebbc3cf2b96b3c81c2c9bdef4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99e3205cb9891522a91482be429334ecab6d93397688a0c52170ff33729647b1"
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
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "-std=c++20", "test.cpp", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lThorSerialize", "-lThorsLogging", "-ldl"
    system "./test"
  end
end
