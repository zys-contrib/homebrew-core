class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b4200",
      revision: "46c69e0e752ff16206347bb12f96ed69f4a01abf"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d6731cebfd5d62d424cc201afa883cfb2cc8ef2b7c189bda6977f575feb05bb5"
    sha256 cellar: :any,                 arm64_sonoma:  "c3358dbdd8c326835c9690682ae53add9264865adb052b20bed144a89c8dbef8"
    sha256 cellar: :any,                 arm64_ventura: "36c913864ba101af1a080d21353da824b1d36f651a2d756a76dd34b8755f5d4f"
    sha256 cellar: :any,                 sonoma:        "12720106511fafba2d0f49ebf8db0631c716ae63d91f4d0f17d873366aff0cf7"
    sha256 cellar: :any,                 ventura:       "7917f2976c2b6876aa36f68ede0688412a0fef3303f3890fa16d3a504032fb1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0570600086c0939a784fb8a35f307ab999c541b6d267c475a8b4c3f452ba49c0"
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
