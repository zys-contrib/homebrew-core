class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3212",
      revision: "8cb508d0d5c024e12692370d85237b45469a004b"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7beb70c05f97fbca1093576975326df30d631b8c4706f0cf7ff1bca477038c94"
    sha256 cellar: :any,                 arm64_ventura:  "b2e5428aa790a69334e98e98994a62cb965c1e15c19bb24cf18395c5879ba4f6"
    sha256 cellar: :any,                 arm64_monterey: "81447a3aeeecddf179ac0b42d0de358be8b42fc53786a12cd108e6701ecb1811"
    sha256 cellar: :any,                 sonoma:         "02126ca9b7c49c45772e5ab000c2dcc3ac1de6f86ae7d51e3a5124df7bcb7fc6"
    sha256 cellar: :any,                 ventura:        "c74b030355e1851fbbc899d887b5603819e9adde82c7e901b71afa48be8bdb12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2bcbfe2e20b6e9cf4b219552fce22b7894f2d3a064ab4398252e96705620f6d"
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
