class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3585",
      revision: "234b30676a97ce227b604c38beb9dcaca406dea9"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "881061ef944574f8f0625f5ce77f9c25871610a85df69ac34da66c49b7c9a6f9"
    sha256 cellar: :any,                 arm64_ventura:  "8ef298c136605d117acc924b143d6f7b15d5c7808413aec2c8fd0b8a8918a671"
    sha256 cellar: :any,                 arm64_monterey: "d96a069a1d68d84421320a10b4d80851a7eda2ff7c3b88ec8855d2b6b88dac56"
    sha256 cellar: :any,                 sonoma:         "0aab349b2371229c2a3c405fccbb9439d64a393036314cd7b465df11af082221"
    sha256 cellar: :any,                 ventura:        "13568aa8ec3b9c1089fbe79ba3e45f024e31470f04fa214c88b4b18cc8bb0728"
    sha256 cellar: :any,                 monterey:       "b597788c7d87c5676153db64633cd6c1c4e49a2e286be91d647305cc394acc34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3de3dfaeadec8100f49c2a6712e8bb42f9e10023dda97a5724683877e4282256"
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
