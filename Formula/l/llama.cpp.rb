class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3287",
      revision: "f8d6a23804f3798ff2869da68c1223b618df09ec"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eec35e609d4e49cb732547a128cc351287a11b3f4b506905028c25b5dd97809f"
    sha256 cellar: :any,                 arm64_ventura:  "4d2db034bbd1a10c08f91d07fb959054a979c6ff4069bacc3e18cadf0367184a"
    sha256 cellar: :any,                 arm64_monterey: "3f9b7800a5990d4fb459ca37c7bb015ca473bee02144c3385af90e479df50cf0"
    sha256 cellar: :any,                 sonoma:         "3754b4f06c7e1684b7eff99a0066b1a54924b55043bdc8d7e4c45d0db3d5810d"
    sha256 cellar: :any,                 ventura:        "97b3a1dde3eae9b4e28d258d126b8b90b2ca340aeffe3b91ce0f12bcf7527935"
    sha256 cellar: :any,                 monterey:       "c004731d0c1dc15d5dbb9b0d48555d504ffb17210cc707b294821d3e478165f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c91bd20e9cc5ae4f2ec85c0d167c605afa911c077edb8effa9d36c4c3ee22c3"
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
