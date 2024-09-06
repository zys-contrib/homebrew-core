class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3675",
      revision: "409dc4f8bb5185786087f52259ee4626be93f54d"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6f63b01972be1dddd5859e817b8567133bf8f34d61f698d5bed9de300dfa35dd"
    sha256 cellar: :any,                 arm64_ventura:  "0ef238833d1eee9270958d2ce6a5eb97ec234ad53c9fa6429cb55813891248f9"
    sha256 cellar: :any,                 arm64_monterey: "0f3c4913e5a630411c31d179a76564b5c5a5fca42c9bd473f626e69bce132a27"
    sha256 cellar: :any,                 sonoma:         "a0f160ee3275d69abbbed407c6ca06f63a1a4c4b92f3835cc138a25682dddedf"
    sha256 cellar: :any,                 ventura:        "ac51c0f527d23c02be7c27495d680fd603954fe0e3378abd5af6fb2a0ac2ef08"
    sha256 cellar: :any,                 monterey:       "70bab920ba91e5a3aea1b2b8b4ffe3d2aa4d882677a70c1fef4ecdcdf1f36e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "841a489fe1abd2a89875074cd387b80c0b913f52d43bc75ae350279e18b77567"
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
