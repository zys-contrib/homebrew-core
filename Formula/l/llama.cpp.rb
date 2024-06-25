class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3218",
      revision: "2df373ac40ea581ccca8a58c713f03ad9d4b658d"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "39f9007bbd51da535422483964bc6715227ee8d313bf381222fdb61058b276ca"
    sha256 cellar: :any,                 arm64_ventura:  "62f5053771d034c1224abeb07dfcf457c47df469a7e1925b63f9df5c56bcda8b"
    sha256 cellar: :any,                 arm64_monterey: "90cc5c0ed95d2cc8f39bdf9563937cc24d643ce56e5ad697946a637f77b50da2"
    sha256 cellar: :any,                 sonoma:         "2c5208942a0bf813e8c4b885353a63dd433c6b9f45ede3a95ef2fb049f2a159c"
    sha256 cellar: :any,                 ventura:        "9d6f55bbf9d39a7e7ef1eb3fc3ff8b98aefea4a5ce4460d6613b74d972b03165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dce0c8f492efe0ab6670e574dd877f802bae314ea186ddd0a78697e76600080f"
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
