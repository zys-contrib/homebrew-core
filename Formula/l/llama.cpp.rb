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
    sha256 cellar: :any,                 arm64_sequoia: "e5838c8b8a8c688fce8759862216844e4fa6d89cbbd7c525d70901f95dde1d6f"
    sha256 cellar: :any,                 arm64_sonoma:  "5a51d6c5caaf37dd7e9f59cc5f7e7aa88ddf75dc1680c7f99efdca0d8fe6d5b3"
    sha256 cellar: :any,                 arm64_ventura: "ab26f9b9755dc55980985b6fc4c789938fd82bb59ac0a214b63bcf6cefaa5407"
    sha256 cellar: :any,                 sonoma:        "498978ad0780ab17df882df8d5ea8536f05cf79f9efb4b15858fdb983b7f5aa4"
    sha256 cellar: :any,                 ventura:       "b2a64df98987109dca5eec9b6ef3ed9ac0c71241c283e29d90f20d320ddd1b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc99a4707524f6090a9e7a58b2c3f8fd0572191e728ae3eaa18e61a619783007"
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
