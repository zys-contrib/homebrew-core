class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3649",
      revision: "ea5d7478b1edcfc83f8ea8f9f0934585cc0b92e3"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dafb56557adf5cf3e588b18d1860563860c6a44e1d84c2a971659f22955ae6e9"
    sha256 cellar: :any,                 arm64_ventura:  "478f72447570ec2d69065245aec79a45b1a01e05cc299b38abec873e0ef30304"
    sha256 cellar: :any,                 arm64_monterey: "870946764c555e88e8c338f7fbf2a52f075b5eacc39eb1b95ed565b4518c6bba"
    sha256 cellar: :any,                 sonoma:         "c8b7b2ed35a043fef12185043b9a79bc34069e3d6bd888a22190731b00928ba4"
    sha256 cellar: :any,                 ventura:        "4207cf1c076495995d74a8410d3ac220f9c2194fd806e5a5da00b53965d4b139"
    sha256 cellar: :any,                 monterey:       "83a299d270510f449ab10d7086c883ab06a1edeed0c6b1b35454dd917e1ba304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c368344bf7b244312ca7c9796cb99e99997eb84447668b3510a856528d19970b"
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
