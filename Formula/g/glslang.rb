class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]

  stable do
    url "https://github.com/KhronosGroup/glslang/archive/refs/tags/15.1.0.tar.gz"
    sha256 "4bdcd8cdb330313f0d4deed7be527b0ac1c115ff272e492853a6e98add61b4bc"

    resource "SPIRV-Tools" do
      # in known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "4d2f0b40bfe290dea6c6904dafdf7fd8328ba346"
    end

    resource "SPIRV-Headers" do
      # in known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "3f17b2af6784bfa2c5aa5dbb8e0e74a607dd8b3b"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cefed08c294b655c3f9f59afff321b5ab171b7485401d84489b363d15d6b5876"
    sha256 cellar: :any,                 arm64_sonoma:  "d1f8ac70040c50625096e9981bba70b8e2dc809e514b3e0c0008a1112317b6a0"
    sha256 cellar: :any,                 arm64_ventura: "96864167e6d603a508e36746dffe21f35bde20ca89b5386ca5e7c126fdde3713"
    sha256 cellar: :any,                 sonoma:        "9075c61713da4f9816536d9548586837deb19f6dde14cc081dd5b624ae3a7862"
    sha256 cellar: :any,                 ventura:       "1df36c523281fd6f3def34d0afdfb2bb3cc07c42aed812d55fe16ee56ab3bb11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c50ddf958a0f1b6c28484a89519e3b51037b7d4027ec3bba007646cc48f3a9ea"
  end

  head do
    url "https://github.com/KhronosGroup/glslang.git", branch: "main"

    resource "SPIRV-Tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"
    end

    resource "SPIRV-Headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"
    end
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    (buildpath/"External/spirv-tools").install resource("SPIRV-Tools")
    (buildpath/"External/spirv-tools/external/spirv-headers").install resource("SPIRV-Headers")

    args = %W[
      -DBUILD_EXTERNAL=OFF
      -DALLOW_EXTERNAL_SPIRV_TOOLS=ON
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_CTEST=OFF
      -DENABLE_OPT=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.frag").write <<~EOS
      #version 110
      void main() {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
      }
    EOS

    (testpath/"test.vert").write <<~EOS
      #version 110
      void main() {
          gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
      }
    EOS

    system bin/"glslangValidator", "-i", testpath/"test.vert", testpath/"test.frag"
  end
end
