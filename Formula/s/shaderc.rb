class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2025.1.tar.gz"
    sha256 "358f9fa87b503bc7a3efe1575fbf581fca7f16dbc6d502ea2b02628d2d0d4014"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "8b822ee8ac2c3e52926820f46ad858532a895951"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "54a521dd130ae1b2f38fef79b09515702d135bdd"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "f289d047f49fb60488301ec62bafab85573668cc"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d7d0830d6cfcd07bcd1adaae9ffa3380a102ccae362d1cffb0d1df55b1c600d0"
    sha256 cellar: :any,                 arm64_sonoma:  "1bd8b4e87db28e9012b8aaf0a587a35b710778f0fa3d53772c90635f08521126"
    sha256 cellar: :any,                 arm64_ventura: "742fa7e4cc9d8d21fdf5996352f0d4b2c43cb06950c143faaf3ebb0817ca6802"
    sha256 cellar: :any,                 sonoma:        "fc8e165521402c9ead5328f4e2d22169dbac818a890aef663b5583e4211a2487"
    sha256 cellar: :any,                 ventura:       "45a6852fc39f206861cbe961f95115f8782a74dad810896e6e25fbbb8726a6f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e50396f2f8d9bb305ce951b14a26021234e66b04903d2d233f26df999a9b3068"
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

  uses_from_macos "python" => :build

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
    (testpath/"test.c").write <<~C
      #include <shaderc/shaderc.h>
      int main() {
        int version;
        shaderc_profile profile;
        if (!shaderc_parse_version_profile("450core", &version, &profile))
          return 1;
        return (profile == shaderc_profile_core) ? 0 : 1;
      }
    C
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
