class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b4634",
      revision: "f117d84b48104992ba16961b35a96fa93efbb355"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "60ea21dc1749fdd4ac36581fdd7d3410dc7f19c9d58c289bd2a57a26ec6682ec"
    sha256 cellar: :any,                 arm64_sonoma:  "ca1babc6014db0fe433d3cf2bd2438cbf4db10d5c0395a0fffb387d0b63b56ef"
    sha256 cellar: :any,                 arm64_ventura: "0861120373206c7d9b65dd542676f202f6892bcbbe7bc42ea94687aa6f9ac2fc"
    sha256 cellar: :any,                 sonoma:        "e2cfc0e0fa483fd73466cfa07f1167bb22a4185622a0fd1a74d00a99b36cb805"
    sha256 cellar: :any,                 ventura:       "9a5e90746a777046d1dba3d73e02a5a1dbebd9fdcdc386aa1c250f501f956b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a8cb35c2d1747b735f071c1e61fbc62d42c6b9c1a83a3ab9b308da24a25d243"
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
