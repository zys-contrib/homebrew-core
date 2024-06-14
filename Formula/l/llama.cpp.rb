class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3151",
      revision: "f8ec8877b75774fc6c47559d529dac423877bcad"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e8834abd72c58fd667e5966af48fb3b0e1e46df64d5795c3c04e7b521ec99a11"
    sha256 cellar: :any,                 arm64_ventura:  "5042d0add56305a86624f59c2c77ca592dcb501ecf63a1c3aa8c62bb4d37f96b"
    sha256 cellar: :any,                 arm64_monterey: "12c9ef9e997972d1ca076e9c29944a286b5b8d2c4de27b82afaec4a4e1c081dd"
    sha256 cellar: :any,                 sonoma:         "ad85cc32b8c3a702efeeae704a966f92fecb8b45bdec5cefa7a177ce068d5bd7"
    sha256 cellar: :any,                 ventura:        "3d4249ebd2e3235140bbe1d7a09f10e89781d9333fe1b30facb856a085023f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13973068bd395c505681b8cb907f897bef047312056c40bb86555a533e80ec6e"
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
