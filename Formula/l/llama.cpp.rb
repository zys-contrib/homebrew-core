class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3789",
      revision: "d39e26741f9f02340651dbc640c9776e1a1128ef"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "389c840c4aaf186e7a58a4d7754f8ffb4f9b2bf986f2352ca84bb67df64cc313"
    sha256 cellar: :any,                 arm64_sonoma:  "0ccf64a3f6648d8ca946bf7a80382b685aeceb92c0aa2ab930349dc87e026fdd"
    sha256 cellar: :any,                 arm64_ventura: "5bcacf0ddc972f0507cee05ee29fcc49b5e064a5fee8263d9ebfa5adcafb0a88"
    sha256 cellar: :any,                 sonoma:        "41d6e746088d63604282a2f63d7e15d5e2f69dbae2cc3a34c7412d33d61df7c9"
    sha256 cellar: :any,                 ventura:       "34ddda35015a40d4881f2d024cd2845f95224c51f2bc51b9c2bbf8113b3dd663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39ebd557f23e493a3b5a742c5655a101550e45f52359b83edc3fc52f30ef3725"
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
