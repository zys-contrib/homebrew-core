class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3777",
      revision: "8344ef58f8cdb8ebd6faf4463ca32ae91c374c81"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d48c204cb9bfd3a7ad01cc748aef574b3513b0bfa386e8da0bccd964e40a5d43"
    sha256 cellar: :any,                 arm64_sonoma:  "c608496aa2dfd870c911d3ebc3339ce8ba7156890e8d446cb9502afeefda2c78"
    sha256 cellar: :any,                 arm64_ventura: "6daed9df35eb479d90ea94bc50fb5350ac5689516df7c970c7cfca94e0e8c4cb"
    sha256 cellar: :any,                 sonoma:        "4eec0ed813518e0a422fc1236d52b32409c5202c400d28d21547deea98bd9f73"
    sha256 cellar: :any,                 ventura:       "30d841188bc23ded1f341aebc5ace457e0a7fa24749ce79e5a8f846a33c156b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55e0a44b9f2ca9ac58dcbb985d36be121bb111992313125aaab782b528e6b228"
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
