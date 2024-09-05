class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3668",
      revision: "bdf314f38a2c90e18285f7d7067e8d736a14000a"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c3fca3b902a403e2a34a11e21221fb6f7ef9baea18e2e0bf17396e372ebbab4d"
    sha256 cellar: :any,                 arm64_ventura:  "47ab0c44a5a80914c518f972d356f7e4fb0deca87a1b7ef60ff62b8f82d42a8b"
    sha256 cellar: :any,                 arm64_monterey: "018206f702dea4769344f92d59bbeed9c5cd10ad6788ffd550388e8eee8b6355"
    sha256 cellar: :any,                 sonoma:         "9507c649b14a71dd2c6f15042eb6b3a14f63663aa5a7da0bff68b62431f0b8e2"
    sha256 cellar: :any,                 ventura:        "d240ea2f1e70d7d36d62ffaf3a255e6ebe2a5c4336357f83b8e14e8e651450e2"
    sha256 cellar: :any,                 monterey:       "f1228dea1596c2b5bc5394101d9f79c291e54d6b5bae0c94649422def06ab21d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e0d12f3afab7d3a74295cd7807728c103a6799abeaaeab8043bbe6db919062c"
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
