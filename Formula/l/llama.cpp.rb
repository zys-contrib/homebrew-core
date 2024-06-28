class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3259",
      revision: "e57dc62057d41211ac018056c19c02cd544694df"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "31f65b0957cd061efa662a1ae612f113a707f454d54a9b30612b826aba239349"
    sha256 cellar: :any,                 arm64_ventura:  "c92db64ee494cc020deee0b56d3887f6c394a883111754499d2a30697869a2a7"
    sha256 cellar: :any,                 arm64_monterey: "61b0c9c3702541ab63639177e89d73739818a8347602852cdcc464a5c834d6f9"
    sha256 cellar: :any,                 sonoma:         "270a97380e413b24d62ffb2bac1e259900d6a03612f7ff3c6431ea03df969cbd"
    sha256 cellar: :any,                 ventura:        "fbf6adf689239b453b073eb6583389851abba4c8cd0625aa4548d80e7afdfc60"
    sha256 cellar: :any,                 monterey:       "967dcd2c42d70bb218ec5d93a328121ec9c8fb07e9ab0c01c7d87c5ffecd9c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0412467b428e035967e7f1ed55244d9e04bd5da94f17c825b4f0414808b47298"
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
