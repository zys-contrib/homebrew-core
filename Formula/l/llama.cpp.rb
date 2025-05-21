class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b5440",
      revision: "b44890df2e4fad0ece1d5366dcbc8bedae23b658"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ade204164831a150452959c0dbc74b190fbdc5539c6ace986d3380005694c5d"
    sha256 cellar: :any,                 arm64_sonoma:  "095abac68e1948c19fbfd6ebbfed469c4ed5224d589315f79d3caf42fdaa7db5"
    sha256 cellar: :any,                 arm64_ventura: "2f72a95c76f14015e1d2c73d5e15cbdc4787b8f8ba477b852164831daa17ad66"
    sha256 cellar: :any,                 sonoma:        "d411e26b70f35dc1263376b6bd89a666bf60e3072bc36642948dfb4afa9b01ae"
    sha256 cellar: :any,                 ventura:       "7e9019fa364016531c56321eedbbc81e581c812cba532066d02e67a67f4404f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "813f3669bfa28f0fcc4845d96992eea3286c49fa54e2c86e6018ad9963de1b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c505a31e895a063fe2e2e1e50a9d1b2c0940d3bc0482ac3f09f4bfb9a7e6bbdf"
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
