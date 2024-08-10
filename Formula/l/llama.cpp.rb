class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3563",
      revision: "7c3f55c10051c634546247387c5c359c9d499360"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2297383ec725057469192675fdd4bd6be1211b65a3ecdcb5ede6343b9e38f054"
    sha256 cellar: :any,                 arm64_ventura:  "6d8f9fe4694fc3158444ef4d9aa89a0fcbcf235d224c929e7d62c66625590d7f"
    sha256 cellar: :any,                 arm64_monterey: "916216a523db300710120958f5015b0c3c45a26347bcfebf37081ae8f3d9357c"
    sha256 cellar: :any,                 sonoma:         "b7325abab7de3094b13f1fad2d984d5398d76dd6c5e6bbfe1f3984b430cc6e5a"
    sha256 cellar: :any,                 ventura:        "00c828eae6a9e77fc1b22f272762ca7886720547e1766f394e39b4e0118bc794"
    sha256 cellar: :any,                 monterey:       "0c6a688091ad26f690f145fe7d6b5affd6233fa8508463717e0ace7b93f2291a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48ec79584967314c6f4a636b76e2883b6240c12181262ffa57185f76a7af506f"
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
