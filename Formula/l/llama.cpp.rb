class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3248",
      revision: "f675b20a3b7f878bf3be766b9a737e2c8321ff0d"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d976b10ad1ddeee7baf2f4980d96e91ee93c3602da76b1795aa03e758388418f"
    sha256 cellar: :any,                 arm64_ventura:  "3e7017eebf6539c0a601e80fd7141b7d5b8cf1bfafdec6afdb7d67c1b9e8b95b"
    sha256 cellar: :any,                 arm64_monterey: "3a29c20d56dab8dcc1f8995162b7426b9ddd011b546542fc7d0722253c04ea45"
    sha256 cellar: :any,                 sonoma:         "f9db7560757bcc7f6629f9e88c82b26e5115375ad2e859fc3c16e868a391026e"
    sha256 cellar: :any,                 ventura:        "207bafa4b2c0e8af56cdf5771dbb01f043da07e8a269a5c5f8acbaae22784a8d"
    sha256 cellar: :any,                 monterey:       "4c51a566861eb9d4bb2e55b41914a738873ad3e869de2493e151dbd1b1f097a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5bfab4ab32466cc2fcaea5730e36c512f869e09091484a76126ffc292d726d6"
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
