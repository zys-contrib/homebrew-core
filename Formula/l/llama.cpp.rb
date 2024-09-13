class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3749",
      revision: "bd35cb0ae357185c173345f10dc89a4ff925fc25"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9a0012315ce63dc7b402fb8a7ee62f951d2f3b7a9c6354b2e9007c8ef2faac4f"
    sha256 cellar: :any,                 arm64_ventura:  "7b386ac3a71677d908a58d2a664a183160a98135fe700a3ed941f1182485b0c1"
    sha256 cellar: :any,                 arm64_monterey: "47d0f3ceb3fe947f3f3285b3e02a0b90afe80afa0f5043041fa444f3c42b7f43"
    sha256 cellar: :any,                 sonoma:         "1d93891457dab50de5c205948bc0d98bdccdc8866def845d64b9581628616f42"
    sha256 cellar: :any,                 ventura:        "eb5db5a039fc0c0375acf54e0f6b55bdbcd57eb691841724f1522eaa42d98559"
    sha256 cellar: :any,                 monterey:       "b291bb33c80b9bd0ac1858d046d973e8c74d023cbf659db22d7d1b9100698dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "035349245d478bf44d58f6e9282945b9c9fdb5ee5a123f8f533cf715770ece37"
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
