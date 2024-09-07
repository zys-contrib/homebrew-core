class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3681",
      revision: "df270ef74596da8f1178f08991f4c51f18c9ee82"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f5e296d7e7183de0ef284a79b547c96be22dabe7322eb8ef992f56fe077f46da"
    sha256 cellar: :any,                 arm64_ventura:  "ec54fcb6ea94556272193448da87ae90d0b878ef89b13e533de07d4af26e9c17"
    sha256 cellar: :any,                 arm64_monterey: "a4bd20619f8446692e3d8a88f7c1e4293861d6d2bb11f9faec8e1e03294fd4c3"
    sha256 cellar: :any,                 sonoma:         "369346e281f234805a4793aec5767ebc414cef922c884bd7041e0bf6e05f96fb"
    sha256 cellar: :any,                 ventura:        "bbeb2718616404174b992c03e8a9071b79deedc02d966e47cb55653d2e26e424"
    sha256 cellar: :any,                 monterey:       "242ee7de4dbec73aa06d692df4decfe904a66c44643ba564255639e0e3563852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c33872eb288752b0e0bc5ba10f5001d792ff1374cf64984f7766641a1587fd99"
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
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
