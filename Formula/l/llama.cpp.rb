class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3488",
      revision: "75af08c475e285888f66556d0f459c533b7deb95"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3b834a9648ef88a333a8e7f7847ef95553737d92b073b89af1812e8616559095"
    sha256 cellar: :any,                 arm64_ventura:  "9a23aee6421941ebffcfdafa9e7e99b55b017a3c011f712882c3d2bd41862286"
    sha256 cellar: :any,                 arm64_monterey: "5555bb346854479fbee8952bb31964f5b488bb52bcf137d1cdbdfc8c43f30f80"
    sha256 cellar: :any,                 sonoma:         "72b0e9558cfe3a23aa6343089800d031b5d202b7a65c20ad380ef5983f80b968"
    sha256 cellar: :any,                 ventura:        "3421109e56d92f0d71b8b594e92899bd9ef942cf2c01923f787cdd88a0815d6e"
    sha256 cellar: :any,                 monterey:       "bd748a50135ad98b727b5194412684639b3492d85844cdc2ecb05d7db0909c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfa38bc7ff4ebad4599539c5dd154b465ab295a7043111f537f885fce352b2cc"
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
