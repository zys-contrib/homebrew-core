class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3611",
      revision: "f63f603c879c2232eaeded8c0aeba4244471d720"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "34b2d4d4f66cf4089521616db5de5191f1a2d7cd60219d1f11d134c3c33e0e2d"
    sha256 cellar: :any,                 arm64_ventura:  "e7d60f8bd86be8c70017484d0d96caaf79dbf1c1a3234fd07ba9125d64568b50"
    sha256 cellar: :any,                 arm64_monterey: "35f02505fee336bc77bb674de1f55daa7227f1d08a41b88b02feb1f678c2e81b"
    sha256 cellar: :any,                 sonoma:         "dae58e17f8b04f3eb19e78c374209709f0c060a49974812901c7f1da869c0ace"
    sha256 cellar: :any,                 ventura:        "69f4d9437854765c7073c6118928f92ba3d9916e2a6c47432238e59fa288df83"
    sha256 cellar: :any,                 monterey:       "230211b2b1217dfad6aa7406a73c0fc80a0f04cca337deb9e33abf2cc26b6997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c77a45b74f18d6f05ea504d834c2080c0488a352fb0de142443400796e2a88c6"
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
