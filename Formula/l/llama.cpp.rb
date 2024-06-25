class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3223",
      revision: "49c03c79cda17913b72260acdc8157b742cee41c"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ece2458971645bcbb88b13248cb9746bc73b60296078bcec22ba88d763fdb76a"
    sha256 cellar: :any,                 arm64_ventura:  "449fd2914062258259d6603aa213885b9562aca12ff76cedc6fe0ff4c24303f2"
    sha256 cellar: :any,                 arm64_monterey: "98e25e5fafaa349ea7640e3748db03301e0524def9d465c3e0a97fd5f625818d"
    sha256 cellar: :any,                 sonoma:         "ae777b7785bd2063efcfc1a31d31316dace2a27d6edbf7dc5bdd11d10871a7da"
    sha256 cellar: :any,                 ventura:        "f4a8f1dcfa4ac89c96d5388f56152820ed83247f163e70e51dfa1795910591fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1a562036fd3aa7b62798425296b528531aefa1b8089923dccfa1d675ac094b8"
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
