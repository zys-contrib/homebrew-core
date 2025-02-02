class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b4617",
      revision: "864a0b67a6c8f648c43ce8271f9cb2e12dd5df6e"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b774b9fd4fb890c991795df6ae3dd968dc7e8744fcdb9ae3a7e4bcbfa2f22e38"
    sha256 cellar: :any,                 arm64_sonoma:  "2fec07381ea40ddd3d8a3316ed084e94647f05de245a5d3ec998cfa763cc7f02"
    sha256 cellar: :any,                 arm64_ventura: "8a9eda1c878816ecdfbd5711d57d3eded42efde5eb028579a6511b74abd619a7"
    sha256 cellar: :any,                 sonoma:        "7a34e86c8fbcd95ce9b18d68d639e4ac49be72aba30080df592cd4d97b41c63a"
    sha256 cellar: :any,                 ventura:       "fb23d609c5d3ec8aea46b453b043eff7e8de8c2d9707212743cd1ba2df4b0877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e8a8760c283f5429fb7a092765021ceca2f4c2660b35ddf2d2b25f7ba934ee6"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_CURL=ON
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
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
