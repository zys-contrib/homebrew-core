class Opencsg < Formula
  desc "Constructive solid geometry rendering library"
  homepage "https://www.opencsg.org/"
  url "https://www.opencsg.org/OpenCSG-1.8.1.tar.gz"
  sha256 "afcc004a89ed3bc478a9e4ba39b20f3d589b24e23e275b7383f91a590d4d57c5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?OpenCSG[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3593c6eaad9f71c123a0812369c2e73d8ba7b130e83d9d8260580ce931e6e688"
    sha256 cellar: :any,                 arm64_sonoma:  "df8adadeacc94919520029a57d1aea0bc10cce4a3283ad8c553249e60111b699"
    sha256 cellar: :any,                 arm64_ventura: "877b8b0e60156bf6b5dbf7ac59bf985009feac839253357ad6053294ebec072c"
    sha256 cellar: :any,                 sonoma:        "c8988828a3e4baf9a1111262498e0253fb30af2b5fb9a0100cb94f12f188d45f"
    sha256 cellar: :any,                 ventura:       "bb2ce70f809a01ca27fdf9a3dd6cfc0cc7befb4d3811cc76e8e8a3735b5f68a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0ab095beec175e194a91f8ee2cdb4019c8e62e639f3f3bf8d52dca372d1e903"
  end

  depends_on "cmake" => :build
  depends_on "glew"

  # glew linkage patch, upstream pr ref, https://github.com/floriankirsch/OpenCSG/pull/16
  patch do
    url "https://github.com/floriankirsch/OpenCSG/commit/881a41b52ebee60fb3f4511cd63813b06e8e05c1.patch?full_index=1"
    sha256 "97e56d7a8bf01d153bce8b5685b0f06eb2befdefa07bb644a12dc79e4143f9ab"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_EXAMPLE=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <opencsg.h>
      class Test : public OpenCSG::Primitive {
        public:
        Test() : OpenCSG::Primitive(OpenCSG::Intersection, 0) {}
        void render() {}
      };
      int main(int argc, char** argv) {
        Test test;
      }
    CPP
    gl_lib = OS.mac? ? ["-framework", "OpenGL"] : ["-lGL"]
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lopencsg", *gl_lib
    system "./test"
  end
end
