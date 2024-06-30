class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3267",
      revision: "9ef07800622e4c371605f9419864d15667c3558f"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f44af34367af53a11cedbd72b4f917f96dcd78f4ef018e82e81396d25076794"
    sha256 cellar: :any,                 arm64_ventura:  "6975372a643541b818c479ee65e52d583392a2cd2f6ba7550bb0267f2c232112"
    sha256 cellar: :any,                 arm64_monterey: "0718fb71f20e6f1f40edab0f141bd55b2cc645229e630de0f850b5e2706cb023"
    sha256 cellar: :any,                 sonoma:         "a804314987362aed25c7b79af4026a5371738eb30f1e6ec02a5f136119a36ffb"
    sha256 cellar: :any,                 ventura:        "3164740c2b865734578423fd9878338aa73389d1e28612d13a396bdc3e6d7392"
    sha256 cellar: :any,                 monterey:       "ae2634b8671456ab7924c187cd08585e208048fedfef37f45662882d25dbbf1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "516c411b7591841c03ba5c3ad1144f7b97a90aa5fcec059df0b591d21be6be6d"
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
