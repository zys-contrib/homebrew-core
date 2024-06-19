class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3182",
      revision: "623494a478134432fd2d7ee40135770a3340674f"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b82dfdea6a1aa24305ceaa81646245ef2e4d93d2e89ff69a84acf02db868de3a"
    sha256 cellar: :any,                 arm64_ventura:  "be74cae670df822adf02964f9b0e12301c74347be1ea513e426fc02a14b3d070"
    sha256 cellar: :any,                 arm64_monterey: "502b9056a769b1f6057d619f26f40e003e61c33c455f6858bca090051b51134f"
    sha256 cellar: :any,                 sonoma:         "33a8341dbd05bbab0ffca6cc40b174e6c28924ece2a9dd99899b66aa6cfd018f"
    sha256 cellar: :any,                 ventura:        "1e878e320f3f6d36ff56fd64cda244c3bab81b1727434bab1236fd09a3ae8cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "492bbcd656f18a759331077bbcdc2dec9922a4ca0f7b95daced1131bf1f9222f"
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
