class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3583",
      revision: "98a532d474c73d3494a5353024cb6a4fbbabbb35"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d7e05c8326208f01da7d2073c4999c5883960fb1e680a6c49c35f32a8b405a8f"
    sha256 cellar: :any,                 arm64_ventura:  "adf2e263f43cc0be4242e4f90e0fc1c59a70a527fc4ff2f462f33c2cb9eccf1b"
    sha256 cellar: :any,                 arm64_monterey: "94c6760c5377513d71548419c8245c2f6d3384fcfed30e757fcc6d49b6727425"
    sha256 cellar: :any,                 sonoma:         "ffc2576af67c05e8def29627d8f9bbb488b77e1a22e4a01834edd2bc797c352e"
    sha256 cellar: :any,                 ventura:        "3c470f21faa25cf926985ccc8c3775156786e2f29651e25fbb2d4a0bb30d9bdc"
    sha256 cellar: :any,                 monterey:       "dd4258934697c50bfac6f6b9fa18e96039392c645c3446dd67465170e2476a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dee13630aeb11325c88b81e82bc746a0f3ee74abc88fa6ede5440afe66acf227"
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
    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
