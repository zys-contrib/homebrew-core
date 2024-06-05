class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3087",
      revision: "1442677f92e45a475be7b4d056e3633d1d6f813b"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ce228051a23b6fbce713b89ed0a6579fcc63e3f7c9b616bd7566100ac311e409"
    sha256 cellar: :any,                 arm64_ventura:  "be0ee9095753e1898094e685f26a00afa9e517eac5896e0194ae969d2d0c5071"
    sha256 cellar: :any,                 arm64_monterey: "285bbbb7f5042dea8a226bd4a02b78daf7256a3aadfd23ac41881626572b861b"
    sha256 cellar: :any,                 sonoma:         "c8cab399be7ec07e2b26b94704e0ee664030f95ef4d5deeae795ba40265ea3c0"
    sha256 cellar: :any,                 ventura:        "c479df4aec69fafdd916d54680aa7a9bfd83cb30d46152c2cde88e0f6f2e2f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36166de5f7118bc783fa65934d7d72cc9e82c2069352c50338fa2797441d7d87"
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
