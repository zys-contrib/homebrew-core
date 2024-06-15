class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3153",
      revision: "0c7b3595b9e5ad2355818e259f06b0dc3f0065b3"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e846df40956d1dd13570a0b4a87235dea0819b883ed9d4f77c9a01c5936223b5"
    sha256 cellar: :any,                 arm64_ventura:  "2b17ffce0a39820c61b37025f97900476649d65ae8701a6e9d5dd239fb155c1e"
    sha256 cellar: :any,                 arm64_monterey: "10bf37a8fbf414aa03a2a417184c549ab0f6173dff129a4a4c9265b30d948430"
    sha256 cellar: :any,                 sonoma:         "19e2a62a99a916e66570f9603a1c226ea7c18e44b82a0deae36d9707ef2c341d"
    sha256 cellar: :any,                 ventura:        "2f39ba64d1f0480853e6ab32467a2a363051a31774a51455088795cb6c2f9c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dca7ca028981da2161f6799f42f3d772f48880a1964ddbf4b1646c170859ab6"
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
