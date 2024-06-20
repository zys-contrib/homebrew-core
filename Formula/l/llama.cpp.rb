class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3186",
      revision: "ba5899315283eb1df3902363daf79bdc5eefe426"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd476c8e70abae8341cebddcf35ef845d7ed0761c2b49e5162b1a3a67720d86e"
    sha256 cellar: :any,                 arm64_ventura:  "6ff93d8aafb58477f60fe3ffb60c5278d58b66a3758fb66a32a77dee53652569"
    sha256 cellar: :any,                 arm64_monterey: "654af337cc45d6bf395cbc6edbff101d2a89281ec767cdd6a1e967f2544ecc7a"
    sha256 cellar: :any,                 sonoma:         "807c5352b0cc2379fdecbb07950f8957312ce8bfdf66a155cb10331cbcd01a87"
    sha256 cellar: :any,                 ventura:        "39b17ce94679398ef4d747b67d4899605de0c61c9038c05b1ccf90f4a1d44cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67f2cb0c0b31b522ef8b0caccfb661e2f413f85605078c2e0db475839837d78e"
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
