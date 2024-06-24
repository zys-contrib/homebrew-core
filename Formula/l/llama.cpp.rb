class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3209",
      revision: "95f57bb5d5b18ef0beb2702a0d6c06e46804075c"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d878616ee7ed9a3ae5f79ec2bbf188dd109678096a46795ec9da6a7210c0e027"
    sha256 cellar: :any,                 arm64_ventura:  "fc87ffb8395f471d65a8cafb8196f53d6833d13d532b3b2cf54a69f0336b79d2"
    sha256 cellar: :any,                 arm64_monterey: "f63139e089a81d08f7718c8d81f65d7dd523c8c0e646028c9da4b3d9ecac2ac8"
    sha256 cellar: :any,                 sonoma:         "9ec774d376647179210bb67442d0557803ca09eba4149a21edfbcfd7f08fdf53"
    sha256 cellar: :any,                 ventura:        "a30b29589cd4b953f0c77aea94dc81206dee5af63bf58020c1eb578eb45088b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "212499816aa1cd556ad5e9701db78e4c269c0d9d484704da89c4e50c5b7d45c3"
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
