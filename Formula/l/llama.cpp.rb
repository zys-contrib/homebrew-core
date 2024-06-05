class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3091",
      revision: "2b3389677a833cee0880226533a1768b1a9508d2"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f173e30951f777a338cad1a08dcded9dbf3e51bfb691d03343dc0f69d64cf95a"
    sha256 cellar: :any,                 arm64_ventura:  "d59b550d0ba154d0a0c625937ac975ba222e43a9e5518b55e76bd020885f87cb"
    sha256 cellar: :any,                 arm64_monterey: "2d96051a433cd4fe8d209e38e661bc020ad678b73208556ba3b08a58d0f73cd2"
    sha256 cellar: :any,                 sonoma:         "b44177d85999f9e24dd4e9e1c72df94a3d3a8dc8e69cd9a269bc843b5adb55d0"
    sha256 cellar: :any,                 ventura:        "823d909a9385232324f2d466b17db6b233bb18dedb6d7868287b82405176f1e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b0edebbf213169e6e532a39efcd3562e9b0ca9f5e1db12e22d0cb2de18bb74"
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
