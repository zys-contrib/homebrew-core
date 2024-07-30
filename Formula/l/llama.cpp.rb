class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3486",
      revision: "0832de723695ab400316a6c49b9f712380e3a731"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "af7077916acc1837e6c8d93ab73dd2bf308497cffc847d5a85ce28945643a9e8"
    sha256 cellar: :any,                 arm64_ventura:  "1e387450992b5f4925af1a8b1496a38f0b0091e1c61e7f1256958876182b054c"
    sha256 cellar: :any,                 arm64_monterey: "326fda72867926b8389dfbcb9b50e58957818330aaca86e860b025508826fa03"
    sha256 cellar: :any,                 sonoma:         "56f720fb36b1e03b0df1e39f771c5d35db8dffd539275e0d0d657e83b65d7de8"
    sha256 cellar: :any,                 ventura:        "89327bb9b365a0da32219d0c58ba746977920d84db48c3bf90b3f2bab8fc599e"
    sha256 cellar: :any,                 monterey:       "b1f9a25816ee9ba882255e4fb88096b11f768c29bfdfed125d065660a381e713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05ab9e0ce77d4ef2afe11521f887e4cd1653bd62954326d2218b735855803a70"
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
