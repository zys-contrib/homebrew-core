class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3678",
      revision: "9b2c24c0993487d3b34a873980e292da571481f3"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d7b3974d16519d81b56689cff183c9178e86027cb467d3052a6085ca2613157"
    sha256 cellar: :any,                 arm64_ventura:  "b970eeadcdbfe988ff9eab1cea5d821624971bd873368d385d23b84a67d8add9"
    sha256 cellar: :any,                 arm64_monterey: "74b438c842bcce52f8862a2763fbbe3ecd3b821e5c77c6a442eb8f97935ace8c"
    sha256 cellar: :any,                 sonoma:         "1ac8f0a8b418fb848068ffed1a5558cae25bdb7aab6dc0a31e3b95809d817d08"
    sha256 cellar: :any,                 ventura:        "cff3453b1f1b2c479e204cb07df4f9750a38e609ffea398e08b9b1a7c264c4e9"
    sha256 cellar: :any,                 monterey:       "1824f8cc0d6c6b959ce2c9ea2d28ad42aea374170f75f4f07b402ab877ad7bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e0bc391078e4a29eb962c178ef6928ef56715519b6e99d09cd4d3bbed552c2"
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
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
