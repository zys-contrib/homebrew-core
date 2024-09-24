class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2024.3.tar.gz"
    sha256 "d5c68b5de5d4c7859d9699054493e0a42a2a5eb21b425d63f7b7dd543db0d708"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "467ce01c71e38cf01814c48987a5c0dadd914df4"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "2a9b6f951c7d6b04b6c21fe1bf3f475b68b84801"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "01c8438ee4ac52c248119b7e03e0b021f853b51a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "df89f0679140f630df19c1faf5d0bc62819257e46c9714d56092d2082a121b52"
    sha256 cellar: :any,                 arm64_sonoma:   "75a5c3c0170541f38928bc7370c230892cceaa9a7fe9e43dd6f53479c2e686d7"
    sha256 cellar: :any,                 arm64_ventura:  "a23023cef71372bca68efa098a1bebb8a0baab3214f9d3ad434c9e05bd96d768"
    sha256 cellar: :any,                 arm64_monterey: "d071ac282a4f7142ce6a2ed53d9f776e5b570d236b9cde4c812b7d9e1b53bb51"
    sha256 cellar: :any,                 sonoma:         "d3911e1746dfd2e49d4900ef5b8253fd30b95df4090d3facc1e95670dd06715b"
    sha256 cellar: :any,                 ventura:        "5c293e476300072c0933fc56f09badd670770dda5faf6c37cfa2f1ee8de75780"
    sha256 cellar: :any,                 monterey:       "02cac858fd503282319ffa2b010bc1499c10c8f041f3cde51853a8e57ee38871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8be0eba9af14d9b4b9f8826cee5e347c7c894be37c50795232e30188a53f934c"
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
