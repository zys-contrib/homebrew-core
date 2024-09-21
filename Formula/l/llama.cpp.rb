class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3799",
      revision: "d09770cae71b416c032ec143dda530f7413c4038"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3efc8a52e3426fc6be6d93fdcd43e2a7bb8df18fa72be989e0ac582e886c30e"
    sha256 cellar: :any,                 arm64_sonoma:  "740ab714b031e53f9f00170426ebfda96378d28e527b22d61c44a46b406b07af"
    sha256 cellar: :any,                 arm64_ventura: "9ce3cf3f62eeaa8c25ae931f7bd5c4df1a20decd41ab5c6ecb9c3646c1f173b1"
    sha256 cellar: :any,                 sonoma:        "2bf7a233c4c0caa8b8758be7421e55dc2459410a64087ae8120fe050be7fe549"
    sha256 cellar: :any,                 ventura:       "8f2a1fdd537d6f794993fa5994f91d4584ce4786b666a4e2e561c50cdee65e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1569cf581441f450f34e2c8c6c4b409ccdcd0922a5f88c5b0a6b3857a4da7985"
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
