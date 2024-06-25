class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3219",
      revision: "083bacce14c1aaf9976aa40e8266cdc25ac749d3"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "11d49fe5d4cfb3ac01d80d11c363046ba300bb89760deaa7e7a72bb40a618206"
    sha256 cellar: :any,                 arm64_ventura:  "63ad62be62ca5b73429b04c0f350f109a4203a0e5162b4901e9f25cbfbb21da7"
    sha256 cellar: :any,                 arm64_monterey: "b291f9a14a85b1a28fc86aee348d8e1415f898a9801841fb9fc6166b846ffc53"
    sha256 cellar: :any,                 sonoma:         "6b380792549e067f032a1cbcfec1dea82e4ad4304514b3e7c25ce9a5d3691607"
    sha256 cellar: :any,                 ventura:        "9bf8f667e7b6687f91c81c676dedec9996af238192b90642b2e515f479a72a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd47275549a5b45abd683fe828606af2f0c88776e53c435f5c7f7520001bfd3"
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
