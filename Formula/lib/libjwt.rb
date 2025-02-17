class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/releases/download/v3.2.0/libjwt-3.2.0.tar.xz"
  sha256 "17ee4e25adfbb91003946af967ff04068a5c93d6b51ad7ad892f1441736b71b9"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "daa5896792307e4f7d10abe0d6cc7ddeb73f3d47aa0df00118084bee5bbb99e5"
    sha256 cellar: :any,                 arm64_sonoma:  "a6d8c2b927ba2a9a2c714a0cad90679740117584a335d09148b27e266da2ad2d"
    sha256 cellar: :any,                 arm64_ventura: "f1c799be3d920d4ce7733277a44068e149852e4160f01ed12b077443668a482b"
    sha256 cellar: :any,                 sonoma:        "ea8e79823c9a61dc7c6e9baf5e22751eeac5d88d70f4a32b4d215ea461697128"
    sha256 cellar: :any,                 ventura:       "abe2f477659a84800560e9e04f1cf75b3a1feedf8b546ce65f0d60c630bd3b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759f89d1e9d8b9ab0fa8fbaada2b5235855d52db35c6106bb4af23d31fb31452"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DWITH_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <jwt.h>

      int main(void) {
        jwt_builder_t *builder = jwt_builder_new();
        char *token = jwt_builder_generate(builder);
        free(token);
        jwt_builder_free(builder);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", "-o", "test"
    system "./test"
  end
end
