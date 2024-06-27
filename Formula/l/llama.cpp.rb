class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3240",
      revision: "f2d48fffde76d959fdb0da37316bdc09e5518eb1"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b8e2366bd6c52a61155b506ee2d62b39a39ecf4da90d43d5f45abe9765c15f5b"
    sha256 cellar: :any,                 arm64_ventura:  "522d1067954c045d252895361f8e437b28492b363c3da8aa2a500098aabef2f5"
    sha256 cellar: :any,                 arm64_monterey: "beff29751fe2438da2fe465c4d178585c063efde30ff3e9aef87b10f2d9a90f9"
    sha256 cellar: :any,                 sonoma:         "205fa9dc9cb027b73b0e08638f1845b2dc971d2995b6de485ab0663bb250b468"
    sha256 cellar: :any,                 ventura:        "091938729b7c0db11a76147974a5d5950336b94a36c452dac84e679ecd24bcc9"
    sha256 cellar: :any,                 monterey:       "b8451030850c66f2dc4b53e5dd6a9145ffdd8493a9bc708e4f94931ec22163fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e5cc6798325094f47a4cccd90883b81e2a006d1b42ee4eaa8c402039327df57"
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
