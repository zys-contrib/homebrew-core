class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3684",
      revision: "e536426ded3fb4a8cd13626e53508cd92928d6c2"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e01b3de66bf34abed58fb8b8c8675ebc7f5540b2634cff82137cb4a42ff0d04"
    sha256 cellar: :any,                 arm64_ventura:  "4984250ab6b37282064d9ffc5b1fe4dc3f68c49bf27f4bc6efdea2784120f27c"
    sha256 cellar: :any,                 arm64_monterey: "591b9ae19ae0f9117de0c866c3690c132d4c276a164af1d33890dbad568b06ed"
    sha256 cellar: :any,                 sonoma:         "ef5e823b84f7a7ad655ee7785d56376d7d0ea5ce1b557d79e39509aff966bedb"
    sha256 cellar: :any,                 ventura:        "8ea99f6af11f102a9cbce82eea540d92ed98dca70eb65ccbf2c91a448cdf809d"
    sha256 cellar: :any,                 monterey:       "bb773011b924265b8a3706217ee58a3bc43a20044801bd80ce7b6feb8b708a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ea9617e455a64009cb679ebbed37873d90435be54717e2343271a3e02ce178b"
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
