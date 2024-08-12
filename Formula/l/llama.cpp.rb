class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3578",
      revision: "1f67436c5ee6f4c99e71a8518bdfc214c27ce934"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c9c79e78f8a4e1f1706b4ae1cdaae4bdc95abcdb575e099eef7c31655e70d929"
    sha256 cellar: :any,                 arm64_ventura:  "5eb42687de10aa45c5a43116e32120799554e6a5e49c1f9704c2e7541a2c7e0b"
    sha256 cellar: :any,                 arm64_monterey: "37da5bbac6f5b3b7194a4bcc5b410186d52870a41eef1207185b625ef637152a"
    sha256 cellar: :any,                 sonoma:         "d300c143dee36240eebed954a3d7fe9b60840f8d8d4976822d73cd490937bf10"
    sha256 cellar: :any,                 ventura:        "18b15fc0d7feaf5d25e5dcba804eb443b574888114279d5a44fe5ed08a25d179"
    sha256 cellar: :any,                 monterey:       "b6e8ff596096e6456687844a4f0000809ed7cd7a0457e10fad0790654c49bc4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "868de2d2b087bc6ec5929cbab77aae5a760d8aa26f5393702ddea66c6da16a78"
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
