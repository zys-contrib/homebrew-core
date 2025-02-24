class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b4768",
      revision: "7a2c913e66353362d7f28d612fd3c9d51a831eda"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d5fcce576d1dc58bd753106d6406ff0e369a15ce59b5c23ccde81ff61cc4bc29"
    sha256 cellar: :any,                 arm64_sonoma:  "7e49b66c3180f8d1e70c2be3e08d86bf8e92b158833ca748249430a281026a0a"
    sha256 cellar: :any,                 arm64_ventura: "9f3f139dc31090351257254d069f873c2ce0451ae301371b63a8b9dd49e1174e"
    sha256 cellar: :any,                 sonoma:        "171f0b970cab0676a700a85f23efc73bc014b133a13578bbafcdf4dd6bfaff1f"
    sha256 cellar: :any,                 ventura:       "d1bbc3ca8a361576adfec1d30332ea483fd6b14ca18a67e82cb284e915d4bdf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b954777faca454a9fdbab03535ccb7990010d4e3e4fe86ab6e35ddf46ec4047"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
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
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
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
