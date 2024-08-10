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
    sha256 cellar: :any,                 arm64_sonoma:   "9ac9669baba1bebdaf026b5b03cca9ab7b3e2b18c24ecce47a904bcadb00af8e"
    sha256 cellar: :any,                 arm64_ventura:  "5eef8789af3a4a0d120146b0ebd65a4f7e22dffe53c02f3d9b8d719b63e5d2a0"
    sha256 cellar: :any,                 arm64_monterey: "246e12fb4263a7f41825ec4bf05d63416e681a942ace81f72a3be2bf319c0546"
    sha256 cellar: :any,                 sonoma:         "33ad388ca9cfcca57efd2e861216850359e479752e00eaf28f9073a6b7f06002"
    sha256 cellar: :any,                 ventura:        "1a7477df3b921f84816e12126aeff4ef29df3eb131205949c0acc4332b537f6e"
    sha256 cellar: :any,                 monterey:       "daf40849780467ca264b429027239d5750c81f129d665f648343cbc67b1ed5e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c1159db8dd7461ed1d442f154741c51d9d4d24d449f227f4bb4cd09b07e7421"
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
