class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3262",
      revision: "38373cfbab5397cc2ab5c3694a3dee12a9e58f45"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "486790c6311e2a9f9f559a1c7fa492b6d7e526e871cc58bba8c004048504de78"
    sha256 cellar: :any,                 arm64_ventura:  "957742b96cdab3939ded4dff8a85f786b1c6f16ce3db4afeaaa50a0e7e13bb1f"
    sha256 cellar: :any,                 arm64_monterey: "f66f5b6bc2a5cb239595d874346aeec389f4f90dae4081e5f11e6fde2be5c352"
    sha256 cellar: :any,                 sonoma:         "e669ba4c0b962fcd0439157110767e7f5e17fedbc2390acf605ea7d4b5a576e4"
    sha256 cellar: :any,                 ventura:        "2794808895025888f772f4deb591871e751120fa0d5ee950986d84e61cdc737b"
    sha256 cellar: :any,                 monterey:       "3ca8d7add601c06377aac407a67ad79ca8d9ceb707b61a97f1b1a5e0a896655e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de108e8bf460bdd5fa366eb8a4382988644729e7464b2aad87ddbc3655405b73"
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
