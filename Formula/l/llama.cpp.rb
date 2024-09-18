class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3783",
      revision: "6443ddd98576a9da904ef9f07df4e4398bb6a01a"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ab4b1894c8b6eb86af9f3b141c81b2c8976d57d5902cba02004d1da6d26950f"
    sha256 cellar: :any,                 arm64_sonoma:  "5c61a1c74858d3e7ab1d93e3fde68b83919f3d1919b57bc7cb391375ad700dd1"
    sha256 cellar: :any,                 arm64_ventura: "4ebcbf353e018e4c96565e0d1fbabc8fed399579921010112ebb15491dbdc792"
    sha256 cellar: :any,                 sonoma:        "a89d411dd0dfd0c8e51199459ee8a0c259dd39242c51044234d7a1a39625b00e"
    sha256 cellar: :any,                 ventura:       "9df652c280c370c683be773ac522c70a720c4f409ef8f3f56560a10d0d7bef53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d01934c3cb5919c00b581631cfb5c6d86c02219d9d4cd342ff4cf39a59958ae"
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
