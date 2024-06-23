class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3204",
      revision: "45c0e2e4c1268c2d7c8c45536f15e3c9a731ecdc"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9764d4e80476b858866c167073cb4378fd6257dcae7b6d72d70451d149f6d192"
    sha256 cellar: :any,                 arm64_ventura:  "6ecbdde7e0713a11171f5c07d49cbf69e4bda6eaaeb0847bbb5b0130f354dea6"
    sha256 cellar: :any,                 arm64_monterey: "1d34dc0d8b29c315e2b07c978678fda3daa800caed59efabf2dfdc2ca5c402c9"
    sha256 cellar: :any,                 sonoma:         "590866301c423ae7eb0a1a77c6047c0c6997871a0fd2bbc99fdcd9bc4c4fb023"
    sha256 cellar: :any,                 ventura:        "9f18d51779123c8d75bd1b5ef26e0f1a5f4d1679f6828d33959d616f0e651854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1144a7212077beeade82db67299b0004d13c68b86e5bcd8c42e6e89b89c890d"
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
