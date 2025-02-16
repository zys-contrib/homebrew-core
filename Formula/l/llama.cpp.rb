class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b4730",
      revision: "fe163d5bf3fb8e99c96ff6d21775fa3d1daee3cf"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "451cc23bf731396e170dd8650a5e7fff351b416c5446ef33d048c5f847f4ae4e"
    sha256 cellar: :any,                 arm64_sonoma:  "67c67842972516993ed5a9d22dd22b02b6a8cafdc8396f8e3937eb72d3ef13b9"
    sha256 cellar: :any,                 arm64_ventura: "736000da194ed5fca79f26177815ad063c2e3f0033e4a8f97920fc42b7ad2a3c"
    sha256 cellar: :any,                 sonoma:        "2a0d32c5cd2ced1fff776815085f2468d5140426b1ec2ec70dcbb6e30171c573"
    sha256 cellar: :any,                 ventura:       "33fddfc9346eb3f4531bc88ce2688261e08dacbde5e65f71ddd4722ef935dd75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1e6737bd6ce58d2c46e96523201242f186231016843ba69480da2274a9aa08c"
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
