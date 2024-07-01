class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3269",
      revision: "197fe6c1d7bec6718ce901f0141b2725240f298c"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d646689c5572cf2b4443ce7f8f58a702f48866c5dd052bcc4dc5e6012efa5ff0"
    sha256 cellar: :any,                 arm64_ventura:  "41d465cb7eb05b154a29433a9d3aba80235440c6c1e9383e00ae309e9277372e"
    sha256 cellar: :any,                 arm64_monterey: "f7f9a19bea00d1d8d131986a04812ed1fa47d908df3a4132af259fcd1c466c73"
    sha256 cellar: :any,                 sonoma:         "887d93a70cb751c437d8b1b1772f61b483777c87e22d8ac5f5908f7d3b93c34e"
    sha256 cellar: :any,                 ventura:        "4ba89d92bd709b58da74c80c73a1c943c7f6705c852c89a5ccb36b4438c6c43f"
    sha256 cellar: :any,                 monterey:       "9debd62bff3f1d37d1480a543fc732730db598b62e05a9b212e4c360bd2c74f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6baae0e47f87751265a528c448fed462c6f4c2d0cae71b3da3d83d840abe5c2"
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
