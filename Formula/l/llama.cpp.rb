class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3702",
      revision: "2a358fb0c4b6e917ac852aa17444cc94dd28a2a6"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b95d4e2c8c7b6165d9a65bff062c428cff95c2b56f81c40df9107242fcb16902"
    sha256 cellar: :any,                 arm64_ventura:  "10c51405a8f581367f02661e1f563cf20de918496f92d2f9e2e0efe50ace49aa"
    sha256 cellar: :any,                 arm64_monterey: "16ede1e308fc8dd7d6822bedeedc1b987f0ca43833f5cba914ecf14960124bdd"
    sha256 cellar: :any,                 sonoma:         "2e4f1b112cd2f30ba50bc8d63651612b0d690aeb869c210dc3ecacffa311bb20"
    sha256 cellar: :any,                 ventura:        "1237f3507b58be2d47673c80fd8a10b6cc2ec842870f59b9a71d39c2fda9fce4"
    sha256 cellar: :any,                 monterey:       "cdfc11995596b3c58ba292a1a1ccf94fce084be2b771e0223322b761b6f2dd6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a00b5cbee5bfbcf00e5e427b2c8764152b0222201d55042067e3ca5791c42512"
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
