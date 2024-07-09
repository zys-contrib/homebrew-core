class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3354",
      revision: "5b0b8d8cfb5ddf2118f686ba6c30fab3f71b384b"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f1d7ea56f982e18265506dfb60392fa0a828619c8bb7ca5253982b0f6e4674ac"
    sha256 cellar: :any,                 arm64_ventura:  "695bc38e1065d904013be4bfb5c18f1f4f402be97403ca2f92a6a541cfaece1b"
    sha256 cellar: :any,                 arm64_monterey: "847802122b5c0af7dc3d52613fcebe857e7aa641f6413fe7d165d4977fb394ea"
    sha256 cellar: :any,                 sonoma:         "906cdc05ea9073fb6e54deb3ec3887c870b2a08122b20a2b97b0f702e2f79c01"
    sha256 cellar: :any,                 ventura:        "9b655b4013e566f7e53abf6d3b5da22838e1f557a31bd0c4bece3a8de8bfbba5"
    sha256 cellar: :any,                 monterey:       "f8181c1db9a9496b62198c95e517783b2dbc3bec7ad4b26367e052d239979e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c93108a82a97ccd2f903851be7d7d51f21150ca4642b9d79a939707851f570f7"
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
