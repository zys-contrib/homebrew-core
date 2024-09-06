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
    sha256 cellar: :any,                 arm64_sonoma:   "3cac1eef9e04bba4777e337375fb84a77e8b17001f15ceb04546a6510d64bea0"
    sha256 cellar: :any,                 arm64_ventura:  "8b7add3f0a95252a45450bd6f72e351a2f12021e9e7f806907b188f8506b86fd"
    sha256 cellar: :any,                 arm64_monterey: "e052d808dd3ace3cba94754b2c7b8bff49f1cf1f700927dcaf5b7a8db2665030"
    sha256 cellar: :any,                 sonoma:         "40ce9d54ed257a5ad457af871948cd7284c14d5aa9b71ff1db86cab0a5c591a9"
    sha256 cellar: :any,                 ventura:        "87c18be5621e7abe90049ac6e6c04a5328138594348b4b56a414abb98bddaa17"
    sha256 cellar: :any,                 monterey:       "dbed06ca55da04a09b7832138125b64080f2770f2d2b1b534e0eb9738724e336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f260dc6b72d43eaf01ec7cadfd6af6410b6b0458116f6ff5a5f2a48521fd763d"
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
