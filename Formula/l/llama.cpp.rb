class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3512",
      revision: "c02b0a8a4dee489b29073f25a27ed6e5628e86e1"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "28d9c43a88b298f3606b71bb78bfae5c2e4e2eb8c4fcb352f19da9697db64c28"
    sha256 cellar: :any,                 arm64_ventura:  "15f5ca3e2230d984ab8942c748749ede97fd16997bdce9b634c8e538400b4b43"
    sha256 cellar: :any,                 arm64_monterey: "3250af5c90e6f46218b2de54268f94b46242e52359a70ecf4a9bcb3ce760997c"
    sha256 cellar: :any,                 sonoma:         "51c1dbce40914be85e47a76916a9c22d7901a2f6069d9a3880532b6958777d22"
    sha256 cellar: :any,                 ventura:        "3f3a4971f92625682828bb2a2403a126895c22e337baa651c178369fd3db7d55"
    sha256 cellar: :any,                 monterey:       "5277589b86d7a9df09b3e117b32197c3cf8c50006fa5d3a8ca2d6581f2b4b263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33d51f88afb6859f74506990fe856a6f4f8c72c00fce8fa65220a3a272682312"
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
