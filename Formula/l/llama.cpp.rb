class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3735",
      revision: "df4b7945aeccae2a71348e5a9c1eab5241e3e0ef"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca0a70ba2b5e51754a681439d79a8c4ecba27d8d4d515a6703d34349ff8b8491"
    sha256 cellar: :any,                 arm64_ventura:  "c9770d83dc4bc39108a006e862342189d23ec5d73a0edd69c743e4a25be17d1a"
    sha256 cellar: :any,                 arm64_monterey: "53ead49535797b500f5fb5de476996164fd7d4a5c473833d046b8791146ac821"
    sha256 cellar: :any,                 sonoma:         "4faf589a5c357411f71b6d5f5c0954219a2bb2f200eec9a5968f4f7093e94107"
    sha256 cellar: :any,                 ventura:        "9b8ab79609078726e12175335319ef02b167122f7ef84c804f0dc1667e75307e"
    sha256 cellar: :any,                 monterey:       "d763b71cd70077c38f61dec0e0f54c5a25e63b26c5c999e30dc6f4ae9dae46da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30f6b779857ba3cfb69a8329a2afb22a675b2652bdf6b7cf53e2d6177e769be6"
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
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
