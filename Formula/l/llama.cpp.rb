class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3664",
      revision: "82e3b03c11826d20a24ab66d60f4de58f48ddcdb"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b8a6e0f6dffe8bb1982726b492af6c43254795fc0f1b85988033bdf9347b31b2"
    sha256 cellar: :any,                 arm64_ventura:  "c9d935330d8238c6b61ca812369a7e5f03f75081aa6d8a40d5e06ffa271efc9e"
    sha256 cellar: :any,                 arm64_monterey: "2cc558efee9553617a596bad95f5a304cd8eeb406337925514ff8b8157b9291f"
    sha256 cellar: :any,                 sonoma:         "d80bf47b3ecbd424056e3850660299aad3e473ea410bf75b72145105af5df234"
    sha256 cellar: :any,                 ventura:        "6f0566a032061c72b0332bfa89fb1950a728cdcbed2e6d3320e3182d66a5f4c4"
    sha256 cellar: :any,                 monterey:       "3773812536f0132bd3db56ed7c12cf23639ce25903894b3cfaa2d29c253f7fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a4841eb04658e78792955772f80b6ca15a799149a43fbed7eb8c81532cd7dbc"
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
