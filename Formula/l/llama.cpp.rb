class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3771",
      revision: "acb2c32c336ce60d765bb189563cc216e57e9fc2"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46c471ea4b4e6d5dc97a4fb77a23c75058cc724c4722a8dd3625adf3bdd0beca"
    sha256 cellar: :any,                 arm64_sonoma:  "e7d2df1e5a1e2c6df59bef9a9eca080bf6d49f357a834e549e8133d3c905c5aa"
    sha256 cellar: :any,                 arm64_ventura: "f12bc17bbd5c9c2bbe1464c91147d58f7e482df73918cf10328f7282eb047125"
    sha256 cellar: :any,                 sonoma:        "652ddb0143826cba6ee14d154ef0ebefbc366e944bc8b40b027d23dd5bfe7861"
    sha256 cellar: :any,                 ventura:       "88868dafe5c409edf8ba3327d9a3baf9f44ca7cd32d980f6361a94884512ec9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "356f0834395a86cda810488cb04385e02a774dcf37cf230dad210dbe79f590e4"
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
