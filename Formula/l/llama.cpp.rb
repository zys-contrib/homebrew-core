class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3702",
      revision: "2a358fb0c4b6e917ac852aa17444cc94dd28a2a6"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d41a8151925ffcd4fd5fea80ab8ce36a41768d4aacd49c7247d2f3a71c88ca41"
    sha256 cellar: :any,                 arm64_ventura:  "029ccdd287a2f968d1b72ebe97c4c1b1aa46a94b50ed621ceba1c7b92da16cd6"
    sha256 cellar: :any,                 arm64_monterey: "3ceab1759323382d50aeda24b34dacb7a44b4f052cb24662f07c22f29841be4e"
    sha256 cellar: :any,                 sonoma:         "09866bb69ca76de6ed8b31dc25fe9bbba2102f5ad8d9697b95ffb13ef03a83e9"
    sha256 cellar: :any,                 ventura:        "1ec682b0977b9236c812e8481e74493f2b6098453999d66e667797747225294b"
    sha256 cellar: :any,                 monterey:       "f29e34d33ad4a286ee9414b5834aafa891e703cefc7f12609bec3888dacc9263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85b7d4e7802b7ab4602db0fdd1bad7414fe174373cd4af8d3d69250d8d99eb86"
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
