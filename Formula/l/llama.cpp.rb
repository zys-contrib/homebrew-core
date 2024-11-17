class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b4118",
      revision: "be5caccef945546ee9fd25a151330a88d785faf9"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd5a99ee5a3b0b2bdfbb0d61dcf849fc7be3cd25a4d05f9ad4203645cfd44d2c"
    sha256 cellar: :any,                 arm64_sonoma:  "9a276232ec9ec1ef16eb8dfe62a5e7ae60d8bc60b33048c1dc92c068cf0af91e"
    sha256 cellar: :any,                 arm64_ventura: "a45471e59ccec69a2ab5f78fd8a64e0db8c75ce1dd9b5f630b2f3b90e667fa97"
    sha256 cellar: :any,                 sonoma:        "4b199c23e0f1e6f5424ee75a169cc87dd4e7493eb3e982ee3daf06d61d91f595"
    sha256 cellar: :any,                 ventura:       "dfdca69eb0911a802a4c4762074b570318e9d94a4ac70b22f9c65292a3e53ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97cfdfbb21dee7247a06284adfee7dfb3518d1380c6a73837187f25ccbe0e743"
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
