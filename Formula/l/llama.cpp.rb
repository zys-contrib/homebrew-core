class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3072",
      revision: "549279d8049d78620a2b081e26edb654f83c3bbd"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "74c9d986d6031be950e3b1c3534d78cd8df65ffc1b0ff9d66e0f6022382db5d8"
    sha256 cellar: :any,                 arm64_ventura:  "af62d9c65eec817fd53772dd1e5c682057a1618cbeb4eb17ca12e9d9f89a85af"
    sha256 cellar: :any,                 arm64_monterey: "6ce107922fcfb1c22ddf09ea2947452d60575e786051761d66d97608a418a185"
    sha256 cellar: :any,                 sonoma:         "d8137c96d9b957b89983b1b6eec49bca72c9e9220e292f910851b00b57484cd1"
    sha256 cellar: :any,                 ventura:        "c3dcb210398dec767c3412453a00f4a3cce46e14f455121de26af2e60eb51a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bdec1675201c7159253e531b734a0384ddb76d068a268b10a06e5166224aa41"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
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
    libexec.children.each do |file|
      next unless file.executable?

      new_name = if file.basename.to_s == "main"
        "llama"
      else
        "llama-#{file.basename}"
      end

      bin.install_symlink file => new_name
    end
  end

  test do
    system bin/"llama", "--hf-repo", "ggml-org/tiny-llamas",
                        "-m", "stories260K.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end
