class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3063",
      revision: "750f60c03e4d3f53fa51910551ce87a3d508d2d7"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "533bda6d877002c8d6ac80bb5caa23614e4a6ee3ba30615e73ea476deb529b02"
    sha256 cellar: :any,                 arm64_ventura:  "c2a97649273fccf2d89c46a3fcef1f10b6460b539c79e849f42db1121018848c"
    sha256 cellar: :any,                 arm64_monterey: "a898cb5b21ebbdf5f5a80a474a450fd31eb082f109eb3b9068ca817d7ecf64b5"
    sha256 cellar: :any,                 sonoma:         "d4012c9b9641663cc555f8dfc59092d4f3e19ff58f56eacd3bf345490cf3b2c4"
    sha256 cellar: :any,                 ventura:        "0fd176dd86e4811bbebba79c1a32eb49bdd8d17dd17bcd4b36e0bb21f525b626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aafac834aabe2baef0abd870e0702083f64c80491e0ea41eb1765ed1531558a"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
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
    libexec.children.each do |file|
      next unless file.executable?

      new_name = if file.basename.to_s == "main"
        "llama"
      else
        "llama-#{file.basename}"
      end

      bin.install_symlink file => new_name
    end
  end

  test do
    system bin/"llama", "--hf-repo", "ggml-org/tiny-llamas",
                        "-m", "stories260K.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end
