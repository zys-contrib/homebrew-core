class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3489",
      revision: "c887d8b01726b11ea03dbcaa9d44fa74422d0076"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "916dc81abecb0783860c3d726ec27b4efc0a6bb709f070771f85def46b1bdb4a"
    sha256 cellar: :any,                 arm64_ventura:  "18238c549fc2fff48f4b381287d4a192f0f7d552f9a3c9804fe0119e470835e0"
    sha256 cellar: :any,                 arm64_monterey: "6ee4c0497e69c1b2d0772224036c796f6305ab84a3b9711de8bc9c79e306460d"
    sha256 cellar: :any,                 sonoma:         "df0748d61d1d03d30abd5590ecfa8d3f7d66b05c7082d7104a2d2d929dffa587"
    sha256 cellar: :any,                 ventura:        "40ec3ca16cabce91f7d2b8cabe5cdd0132f194b7ee1817a7e86bb132b1dde571"
    sha256 cellar: :any,                 monterey:       "f6a47a82210ddef3df5a36c79b233184484b91a876e0884534833954f6281211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b66958afc5dd608cebfdb5d26105545dd8807233fd455a154661939a723750c7"
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
