class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3807",
      revision: "37f8c7b4c97784496cfd91040d55fa22f50b1d57"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "61735bc6f8740ed01ed86cf14ed8c00f7f5aad93a18485d3654b35187ebccae0"
    sha256 cellar: :any,                 arm64_sonoma:  "ca4b677343a0f87131ab3a4d33a8ab008cdef62a9ad31a4dcc67ec86fce1ec61"
    sha256 cellar: :any,                 arm64_ventura: "e8a228c95b979a62d0fbd8ad19a6ed7223f81009cdb2c5e35f13360e56e2f0b4"
    sha256 cellar: :any,                 sonoma:        "8ae911aa535abf92e77230bd8c8cfb2478b84ff6d7b97fcc41cb198142346ed6"
    sha256 cellar: :any,                 ventura:       "f4b39ce7e3d2dd5dee31656f9f19d0af3f81678d69270709025b1354ef7753da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fe20cd6c56acbe447ff407000a642022a8a0cfe83f612b2c790aeff017acf8b"
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
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_CURL=ON
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
