class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3184",
      revision: "9c77ec1d74874ee22bdef8f110e8e8d41389abf2"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "77839dc5041669c57225944cf7e728e925ac9032ef10dcd682f503ee862618d6"
    sha256 cellar: :any,                 arm64_ventura:  "0063d14284c68ba89d1cb47878fafe852252ac4924e0d9da9b7373483f5dc36f"
    sha256 cellar: :any,                 arm64_monterey: "482aa27462dc69f50a7b7a2da44d23f6b5da73cd4f70340b4969b7df2bf7df64"
    sha256 cellar: :any,                 sonoma:         "2f4b8e285ed71787624217121a3f9aa79815a0cf0532a68e4b601e2ab514e6a4"
    sha256 cellar: :any,                 ventura:        "1e55eaafeb32f56b5b68f8671c3bfe7199a4852b027dfc3fb4904767b13950ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee53887c81b7737dd3f88e2f3cc2ef74275af3aa9336556ec560c0f146b9701f"
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
