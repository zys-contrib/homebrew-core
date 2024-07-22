class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3436",
      revision: "50e05353e88d50b644688caa91f5955e8bdb9eb9"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "505b3628f53a64a7ec8ab92eaa6b331a5356be01d867af5b7b1650a9d9620d02"
    sha256 cellar: :any,                 arm64_ventura:  "c7db7e4a03b0720618642f4d88aa0e176d694105d82fc0f03fd39463bf4cc4f7"
    sha256 cellar: :any,                 arm64_monterey: "0d217f0797847e7e56330d652087fe703ba0e8628c6ab15eb08bb5ef61115b58"
    sha256 cellar: :any,                 sonoma:         "e1102f415bde9f90b35b69d7f39a9c82d6a5e1c9e862116359b213e156a8e8f9"
    sha256 cellar: :any,                 ventura:        "73374031545358dac0063a468d36e70d43d58e6aff1721827b70b7f5091b50cd"
    sha256 cellar: :any,                 monterey:       "45b55c63021dc0d7d6b15e3a030a770a1313e68b5892e3bae3ad48f0d0553ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b9a8c194dd177025607834a98d5a6977b7957498f81ba9d198bc4c131b6efb"
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
