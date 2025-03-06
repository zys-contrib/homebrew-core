class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b4835",
      revision: "94bb63e4f0f6135579b88e5700ed40cefa374e09"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ad653d4a67204b86d1ed01c1a2122b653699bd6c49191850e2351db831d41be"
    sha256 cellar: :any,                 arm64_sonoma:  "3a2a86cf35c88ab39dadf5c1a674e8a7768ed19c1bbc8c8f2ec3fbc3378a7e70"
    sha256 cellar: :any,                 arm64_ventura: "2566e9b709fc78d3181d9056d6d43adaf58d78ad8d6026449fad7490452996e4"
    sha256 cellar: :any,                 sonoma:        "ff7c4a05c2c33162b231e8b8bb01619b0e1cfda31c08630171e7ff3e61d9a99e"
    sha256 cellar: :any,                 ventura:       "a5edb5ac29b5a9e688f43097e99dd1a52b01f7d08046dc586fb15f4eefaca624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9c596b2b521e992c7bd4218e0548b299eb6dd36f45e435f2d0f3f32c8be0e90"
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
