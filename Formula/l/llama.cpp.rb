class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3290",
      revision: "d23287f122c34ebef368742116d53a0ccb2041ee"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "50b9cf9496b9037e6ee5136bab5982deae0fb643722b10d5cd6a0d93ed13043e"
    sha256 cellar: :any,                 arm64_ventura:  "e6e7fe92b2fb8bee2da161becf7644b88badf2e9f19d71f98271d5570ec878ee"
    sha256 cellar: :any,                 arm64_monterey: "439376925c40c6fa4845c1f97feff28a29e1241f82399199967465ab98622c76"
    sha256 cellar: :any,                 sonoma:         "a9a6042303a101b135a3c49d824376af9639c90fab3ea6ab5bc31f92463e8127"
    sha256 cellar: :any,                 ventura:        "4890826641dadc0a44cea4e51d4fd3ca63cb804ef23ef06c0325e931380fbc49"
    sha256 cellar: :any,                 monterey:       "76ed25f3d10ae79c725925fdf45322ae25eb6d5e14e5dde3b54e76cf69793d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ffc98baa881f7443b13afff494dfb791befcba0ec43d137fe9a973703c27feb"
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
