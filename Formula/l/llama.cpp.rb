class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3368",
      revision: "dd07a123b79f9bd9e8a4ba0447427b3083e9347a"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d6fbd2cb832a4b027b8a2aabf02a326bb1e13b98ccf49c238adbee63c0741a9b"
    sha256 cellar: :any,                 arm64_ventura:  "04349d7d6a15d570f8c1d45bc5188efe96ffed25fc8e185c1bd1945a4be11291"
    sha256 cellar: :any,                 arm64_monterey: "b27db19e5cf560b0d2336ee2a4f740f79ca4fc3c25b2f44d21de8279f25b8d23"
    sha256 cellar: :any,                 sonoma:         "51712c851b1170626e502d38ed44be41122916bb416f220b9d5f4fdb44d398a2"
    sha256 cellar: :any,                 ventura:        "860b064b054e6a34569bcfb9841c898a09a502977cc192876463616958bb7efa"
    sha256 cellar: :any,                 monterey:       "5a525ffab44ed8940f2954af0db598ee02114720eea078bd6af393b809088430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5d2dfbfd4a70b20a918a6422895a873031ee499f72912bf6879db7ddf1ff45"
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
