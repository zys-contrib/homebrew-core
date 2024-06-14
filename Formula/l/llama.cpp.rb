class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3147",
      revision: "6fcd1331efbfbb89c8c96eba2321bb7b4d0c40e4"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cbf0cee0b1be6f1b3d8b5735b3098fbaed0c77731418141ebb0dd16ad7d223fe"
    sha256 cellar: :any,                 arm64_ventura:  "f142c8ddb80932b9ca973de35957db02585bdd75960b0d4ca21bd41f9be75dab"
    sha256 cellar: :any,                 arm64_monterey: "6e4512849b6f0008f55eab1794c1792613aece26a56ff9f8bd925a3f8d3c7002"
    sha256 cellar: :any,                 sonoma:         "99cd86cbbc0e363b6d3d7385f41684f088b43cab4277c3666a354fc854a7751a"
    sha256 cellar: :any,                 ventura:        "4a51fe30dbdc20077e7b626fcead410909d8be01ed295979b8f37de5ac6f271e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecbbabb22a4ebec271afacbc44233581559f0d22a4adfc0d97b460c9f5350da7"
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
