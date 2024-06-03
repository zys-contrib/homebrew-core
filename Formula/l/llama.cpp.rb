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
    sha256 cellar: :any,                 arm64_sonoma:   "f37f2f87d9861535988c43703a92b377c96c373c25477c3a42dcb075f62e9353"
    sha256 cellar: :any,                 arm64_ventura:  "642a21a12e8febe22d5081ca914c9af38e9399e37559cde8eb8b981ec7603839"
    sha256 cellar: :any,                 arm64_monterey: "b25fd99bce22c51778bad6e235fc498e4a2799f04dd547d47b9467c5d93daaec"
    sha256 cellar: :any,                 sonoma:         "fda8d8fe4a0cd571bb220b86cdaac5d840b0fbed5f07139c48e4f50445d3a8c3"
    sha256 cellar: :any,                 ventura:        "4a12d38e5dfb97f982a9d8b2a5cf74f3705a6bb08c217c8de8965275e9dd14cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95f953af05b8604fb248f060d11e0eaf8125466aeb69e5f0ff20afb20e14bffa"
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
