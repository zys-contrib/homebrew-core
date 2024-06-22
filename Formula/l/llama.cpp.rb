class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3199",
      revision: "5b48cd53a87928db0c6447f0c9dac4db5802102d"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1c33c425c69bb0bcf3be675574047a934a33ee67b39e116e51ed07bc36d4976e"
    sha256 cellar: :any,                 arm64_ventura:  "49ae4306e49042b7aedfb7c17b6685a2330ec3b6af2f5b5c1ca6342f55de76aa"
    sha256 cellar: :any,                 arm64_monterey: "485d2e7da5a5db7869647ae495bdbf6af8272e7cdcd4ae9456627e976f55df79"
    sha256 cellar: :any,                 sonoma:         "07eec4a9a08d05f48255078bcf6780cc7489d6a716b00c2aa10e9b9ce5582411"
    sha256 cellar: :any,                 ventura:        "f520172d42a5d6178c7d9979c02391a422ed46063f8b337665358008378f28f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f69170ff8cc8a47ec956b087326c7ddd9bdfbcb8e4e6cdb6de10f3fd951e814"
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
