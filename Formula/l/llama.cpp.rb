class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b5400",
      revision: "c6a2c9e7411f54b0770b319740561bbd6a2ebd27"
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
    sha256 cellar: :any,                 arm64_sequoia: "844a40ec13d0681c02993e0690d20f87d9ec5cf6fac66a9256fbc0ef0be943fb"
    sha256 cellar: :any,                 arm64_sonoma:  "7485d208afbbecfb3e6b169944ee2ff9935eec0af27f49e4e88a115534050786"
    sha256 cellar: :any,                 arm64_ventura: "0a320be8e764acb2d520f3bce09aef1a7a59d569c5bb40ddbe505279c21b8e92"
    sha256 cellar: :any,                 sonoma:        "75e2d854db7b1433225b2af616748cbd947ecf23915fc473a32539edbb3df3ca"
    sha256 cellar: :any,                 ventura:       "b76ff94d11ddb4da45ac777fb46a682ccf4df8d4134a8557499800f7abd66eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "119fc7dedc61a097a4cd97d9392df82b623f0fb120b50dcdf2def811dffbb331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4073c3ec0d51eea2fc193c6394d995c2c0eebe440f75ecd37fcf9418178b947d"
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
