class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3353",
      revision: "9925ca4087a34ab973b07bf06c0b770cb586830b"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f3ab1ba6ba4949ede7b8c51ed63743ba05e86e37beb918834eb83c9f0a8cb1a5"
    sha256 cellar: :any,                 arm64_ventura:  "8de415c3ec330713855ee1e1a5c3a9316cfeafe85ffdd70e9df655aa75649765"
    sha256 cellar: :any,                 arm64_monterey: "0d335417374b1f0cd38292037bcedaee1ca5df0dd3070e8521f903a8fabc10ce"
    sha256 cellar: :any,                 sonoma:         "6d31fa589ab9e63c9094bbb184bdfb58eb68eb79a5357b45ecd1d6284c7c3ff1"
    sha256 cellar: :any,                 ventura:        "61594bd375fd9edcd1ac39161a78d872698a81163a5aae7d1591288ed6d6f597"
    sha256 cellar: :any,                 monterey:       "afe358cb7abc1a7890ef453fa8c366ca06285d20d024c711ea1ca7097f251446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "befe88d498d04f286b255c53a4c14f2fa9f0a416472f215f74f5a14eafd7d82d"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.children
    bin.install_symlink libexec.children.select { |file|
                          file.executable? && !file.basename.to_s.start_with?("test-")
                        }
  end

  test do
    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
