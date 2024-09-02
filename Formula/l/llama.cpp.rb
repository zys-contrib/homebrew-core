class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3654",
      revision: "b60074f1c26d8354053a952844ef3f7ebefd8803"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0236a6ae0301abbe84d534078322c0f1dfcb77dbcb0ba4c1d0855acba3d49c6e"
    sha256 cellar: :any,                 arm64_ventura:  "4e3e9412ed843d68d840c80f12d4c66227e450d9cbe4b308ad8b992031ca00db"
    sha256 cellar: :any,                 arm64_monterey: "3145682ef421eb600d83ffe58a037a22a36bded0f63e3dfe9c7d8148da873460"
    sha256 cellar: :any,                 sonoma:         "2b856fcefab210667dd19d31b0c58478aed96594d440d01b9312a242e2dabfe0"
    sha256 cellar: :any,                 ventura:        "3235f809da04dc6d80dc514206b38b709c10aa0cf21635991248254f9cfbc0b0"
    sha256 cellar: :any,                 monterey:       "9be7a2692e5990cb7580fee6a21cf228db245e1b4aa2e22717c209dd103e5a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4c8b6b4afb4b12bab6393b7a9608c054d59a0a000567d6de85c7aaa5364ec7b"
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
