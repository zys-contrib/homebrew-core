class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3779",
      revision: "7be099fa817e9c53ffb4c3ed7d063e1cffcd675a"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc6cc2bda1b05be83ed29ecbb711a86f5fc400b5bed8a08ec1fd72a9593514ca"
    sha256 cellar: :any,                 arm64_sonoma:  "10fef69e0d54aeb66812b73a97b08ae48bd2ad7985f9ea4e845edfb3a1af8d2e"
    sha256 cellar: :any,                 arm64_ventura: "38d11609e0ee20d1c6939f65d558414b0862863741ef2fa936dc001f030a0dc2"
    sha256 cellar: :any,                 sonoma:        "f5e61f8ca235df1966894e6a6ef54659e490928a0fe17ba3fe5e0c67bd0f823e"
    sha256 cellar: :any,                 ventura:       "246b84c863192409f14ac92bb6902b0275f1eb5e9b0c5e917719e4cbe8d03940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7faa03e69a32e6edbe128054effd1245a88a95074bfb600fca3582e8117a72fd"
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
