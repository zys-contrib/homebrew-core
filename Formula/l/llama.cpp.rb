class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3156",
      revision: "cddaf028adc738b5a7ecc60809cb78e0ba0f97c1"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c2680b6d18096caf7acf460aad8723dc201264264396940f547af1937baf1ec3"
    sha256 cellar: :any,                 arm64_ventura:  "6def7734daf340eaa53888ee6c42f66e51e615b588204498fd8835ba8ce9e79b"
    sha256 cellar: :any,                 arm64_monterey: "160ea1bfc8cece16bd6342a9bd810d412ebbc3fcb227ce1a30480b16b18b6f7b"
    sha256 cellar: :any,                 sonoma:         "8c88614c1183182c5ba6fabb1dec214f3afad13cb429bd5f74fc2ace77335696"
    sha256 cellar: :any,                 ventura:        "95804191d0f844058e4d6c1950f15a23af78e3d53d3a8519efd402f075773b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d85cfbef6c0929586cd05ea3e141e8e96a9ea7a66d45b692f76c02ad0535d38b"
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
