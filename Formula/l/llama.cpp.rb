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
    sha256 cellar: :any,                 arm64_sonoma:   "69f4bd1baf51f155361827d00ed3e15abfa3b9fe898dbd7ad7df561e3a4be43e"
    sha256 cellar: :any,                 arm64_ventura:  "7f40f9af4ca252979679b6926bec3a2d10c523a504570d24d22146c55aa2ac47"
    sha256 cellar: :any,                 arm64_monterey: "270cde0f2fd23a3538aaf5c4dbe48e128168da0458e53d6f61460618cd544901"
    sha256 cellar: :any,                 sonoma:         "b8aac086df46d73074b61fba096f128ec588fe5e01081a7b79b2a63256c03218"
    sha256 cellar: :any,                 ventura:        "7a8f2ce3d2b78e1b000d9a8272f38f7fb48b1bd4274a391c6c2b4d0e74f88085"
    sha256 cellar: :any,                 monterey:       "0e751a520b37417f086d5f03a76a155aedcb45a71b8aff1cd9632f9ab5c1637a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ca62adc1331d27c0f74200b24cdf3a4186b21cb302c4ee9b52fb4c3250dc242"
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
