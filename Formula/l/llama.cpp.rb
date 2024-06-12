class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3140",
      revision: "a9cae48003dfc4fe95b8f5c81682fc6e63425235"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ccd4711114dd8747e1fed554b7be1b987082d9ac1f33681cb63a8af63fcc4c59"
    sha256 cellar: :any,                 arm64_ventura:  "40dfdde580afce7862f513bcbf98f138ebd4ab5d595a46626181372c853938da"
    sha256 cellar: :any,                 arm64_monterey: "dc9260b5eaec8c43b001f1d798693b2cdc250e0b0b66e8912dfa9c5543dd48f4"
    sha256 cellar: :any,                 sonoma:         "5f439a885e446b1cb0232b1f1006891eb95ed3e6844c37f30c864946b8f56cc7"
    sha256 cellar: :any,                 ventura:        "26f653349b0a87155cff456e23ef5fa4ff8ced8aecb549d8f507b6a5d2f146cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aac1041a16baa3809a9bb1d7524fe6ebbdccde600b03f4d4362f50142c67af8"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
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
    libexec.children.each do |file|
      next unless file.executable?

      new_name = if file.basename.to_s == "main"
        "llama"
      else
        "llama-#{file.basename}"
      end

      bin.install_symlink file => new_name
    end
  end

  test do
    system bin/"llama", "--hf-repo", "ggml-org/tiny-llamas",
                        "-m", "stories260K.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end
