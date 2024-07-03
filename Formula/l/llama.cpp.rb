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
    sha256 cellar: :any,                 arm64_sonoma:   "7c9fa45a547592cd0baa7a226ca782d2ee3bbd72c2c5f28735374233be0d28b7"
    sha256 cellar: :any,                 arm64_ventura:  "7603dc10e791a901dede81b23bb8514aaf1fddf8459179fbd61a47d17d985faa"
    sha256 cellar: :any,                 arm64_monterey: "d321ab5406335ee195c27a3a8ac7b52b23950d18029c50ba9258cb3962d36d4e"
    sha256 cellar: :any,                 sonoma:         "bdc1cdd214405370320eb7d2a33d3a539ede5bedb5a3d5b62d794c25293439ec"
    sha256 cellar: :any,                 ventura:        "e7ea79fbb1cccdbdf3848da2672a88e2f5330ddbd6f6c760efbc926bc609cc51"
    sha256 cellar: :any,                 monterey:       "7da1f97fcb8d2bb5d5006cf487f7c31c7f103d9c32025813a88d2b4b879518e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cf911d2196e55fe31fce0216756694d50350c292035b9632c3f493f920e6569"
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
