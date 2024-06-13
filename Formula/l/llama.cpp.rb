class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3145",
      revision: "172c8256840ffd882ab9992ecedbb587d9b21f15"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "74ab820fa14edfe684ed80de1666e7dee3ff66355991f75ce745f7964b45f396"
    sha256 cellar: :any,                 arm64_ventura:  "3f5c5ddf161a60359565e00162d74e94be636c90661099f54f66f92970c57c39"
    sha256 cellar: :any,                 arm64_monterey: "59d82322a639de4e7a01d1351fd48f0358e510fc4d29e71472079f87d1fd47f6"
    sha256 cellar: :any,                 sonoma:         "65731eb53b0c2f1de4a6fb9857f20fcf9d60e128349b8374c94d3890e28f8653"
    sha256 cellar: :any,                 ventura:        "ee91e540f1b2526fc039ee7e365070920449e4ff43594606005511a3f90a2ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acb62a5b9b2122481e5eb1ac923dd32a338ce8ae09119beda24b9b53bf4e5ee7"
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
