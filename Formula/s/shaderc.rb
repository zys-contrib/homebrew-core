class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2024.1.tar.gz"
    sha256 "eb3b5f0c16313d34f208d90c2fa1e588a23283eed63b101edd5422be6165d528"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "142052fa30f9eca191aa9dcf65359fcaed09eeec"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "5e3ad389ee56fca27c9705d093ae5387ce404df4"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "dd4b663e13c07fea4fbb3f70c1c91c86731099f7"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e91b9ca535fd4f4251290a9f05aab1d3714ddcff8a64e7f1fad846cf668ad03"
    sha256 cellar: :any,                 arm64_ventura:  "f88f181544dd8ec38a3a8205183dd8ec02c7b89cd2c252266dd9bd980f5dac23"
    sha256 cellar: :any,                 arm64_monterey: "b780f4fadce463d060e6cb9edd9478b1cceef8005295fa108f61768e42fe3ba5"
    sha256 cellar: :any,                 sonoma:         "bdeb7745584aadc9a24a10f9c7db8b4a4f4e7baadc02d10f3e884295d138ebe3"
    sha256 cellar: :any,                 ventura:        "a2d99fa5c1d74b5c01ca09f6fd1924b76df3a4a383da5bcf1a348f14198b4b7e"
    sha256 cellar: :any,                 monterey:       "1a2b71042aa305fa2a879dd06554e047c40ddbb876abe116304f2565eccd5794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "757ba7d2e4c50e297b9dce66251b273968628b14e574399b58b67f0710f4e5a5"
  end

  head do
    url "https://github.com/google/shaderc.git", branch: "main"

    resource "glslang" do
      url "https://github.com/KhronosGroup/glslang.git", branch: "main"
    end

    resource "spirv-tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"
    end

    resource "spirv-headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  # patch to fix `target "SPIRV-Tools-opt" that is not in any export set`
  # upstream bug report, https://github.com/google/shaderc/issues/1413
  patch :DATA

  def install
    resources.each do |res|
      res.stage(buildpath/"third_party"/res.name)
    end

    # Avoid installing packages that conflict with other formulae.
    inreplace "third_party/CMakeLists.txt", "${SHADERC_SKIP_INSTALL}", "ON"
    system "cmake", "-S", ".", "-B", "build",
                    "-DSHADERC_SKIP_TESTS=ON",
                    "-DSKIP_GLSLANG_INSTALL=ON",
                    "-DSKIP_SPIRV_TOOLS_INSTALL=ON",
                    "-DSKIP_GOOGLETEST_INSTALL=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <shaderc/shaderc.h>
      int main() {
        int version;
        shaderc_profile profile;
        if (!shaderc_parse_version_profile("450core", &version, &profile))
          return 1;
        return (profile == shaderc_profile_core) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lshaderc_shared"
    system "./test"
  end
end

__END__
diff --git a/third_party/CMakeLists.txt b/third_party/CMakeLists.txt
index d44f62a..dffac6a 100644
--- a/third_party/CMakeLists.txt
+++ b/third_party/CMakeLists.txt
@@ -87,7 +87,6 @@ if (NOT TARGET glslang)
       # Glslang tests are off by default. Turn them on if testing Shaderc.
       set(GLSLANG_TESTS ON)
     endif()
-    set(GLSLANG_ENABLE_INSTALL $<NOT:${SKIP_GLSLANG_INSTALL}>)
     add_subdirectory(${SHADERC_GLSLANG_DIR} glslang)
   endif()
   if (NOT TARGET glslang)
