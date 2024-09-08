class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3699",
      revision: "a8768614558262b6762fc0feeddcc6f7ce4bc5fc"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "815b0b7b6369c82f6159fb78dac83b45ced008e37ce17ca4ddce4e138b17cd03"
    sha256 cellar: :any,                 arm64_ventura:  "b71aca22c6d62d5db79e1c881d04f492b1d1b14a6c17ee217b3b1c5147fa8b35"
    sha256 cellar: :any,                 arm64_monterey: "aa4282e5278b9d1e9a76a558fe8a1316c4bb67901163d7d9bb3183d1981ddd56"
    sha256 cellar: :any,                 sonoma:         "9255f3b0957958707d1b2b6d5d6c623098c2d951ceea2d2a0eb497c7e4e9a2fc"
    sha256 cellar: :any,                 ventura:        "9e5d1cd9eaa04a146979cb7acbaa0bb39ae14772320f05a0de43d397bb222074"
    sha256 cellar: :any,                 monterey:       "c17e442773b2eac3bdfc35a60c5253b9f5db842d7df0abc599d5fc8d59968de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef84f2a5a355e9734013eed2c621fdbdadaefe4f24c460374004f726fef3e0c6"
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
