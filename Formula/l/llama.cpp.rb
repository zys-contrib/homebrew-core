class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b4095",
      revision: "89e4caaaf081f4712af61a3e08cb67b406c02b80"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b31699e662e832955478db73535895ec7e5d7c209d4664ff28624fd0781911e8"
    sha256 cellar: :any,                 arm64_sonoma:  "f7667fee369382a574b49f0e4aae9139f4b40fe56f36b6d1b7cfa353de93fa1a"
    sha256 cellar: :any,                 arm64_ventura: "d9535ae21fd7cd054356873df9c76e0199506b302f944463698bc8b47f99ae5f"
    sha256 cellar: :any,                 sonoma:        "5eaf0d81889a4699600001501b8c742c6e3f438cdaeb1fcae1b3ae323d068011"
    sha256 cellar: :any,                 ventura:       "18a34007d2d9ee80bb808963973a722c7447e7b1bb25681dde1dd35afa704c8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f803b0dc2c59499d59337e1d569c373b6ef241671e27fcdea620c240eeb74b7"
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
