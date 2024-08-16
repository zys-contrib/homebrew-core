class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3598",
      revision: "d565bb2fd5a2a58b9924a7a34e77a87c78c52137"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e00455cdc5031b85c140d6d91638ccd294258d157fcb0ff8123ee0b03729f96b"
    sha256 cellar: :any,                 arm64_ventura:  "4199439b051e3474abcfb33e9457ae9d10002c08dfb5efd66f491b6ac5317cf7"
    sha256 cellar: :any,                 arm64_monterey: "f785d647785dfc5918257d0e348d41fcc5a71d8d975aa83026dcfe087e4be1a8"
    sha256 cellar: :any,                 sonoma:         "5dff411fcf03aecd8d87c9281b01da3d785c81a6687312b9de30b7166e0060d6"
    sha256 cellar: :any,                 ventura:        "781d3a05ce98e920d92e3ab9561b96f5db30d264b4dff8dbaaa7273d2cb73181"
    sha256 cellar: :any,                 monterey:       "fc5846f409e65dd7a3959bdd2ace991bad1ef2e402b2eb1b8702bd34dede537a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb1224a1f3ac2b9b1514aa39f3bb6e8f7282991d260ff911eaddb6007b744d4c"
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
