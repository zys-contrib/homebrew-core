class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3154",
      revision: "7c7836d9d4062d6858e3fb337b135c417ccee6ce"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bc8d53c1cc00e68b149ac0c9c6022acb4ac314a34b405653893ebdf8c7628454"
    sha256 cellar: :any,                 arm64_ventura:  "a5038112493b5f9a9e3d713a2f3d77359a9bd4054a796f992f2cd9b013d1e541"
    sha256 cellar: :any,                 arm64_monterey: "3e2ee4cc6c2fdae3b270468aa29d55f9d989a6eca476dfb395659da44cac97cd"
    sha256 cellar: :any,                 sonoma:         "9f52346bc7a805b41134a88fa5d74e8529252f6a743b62b0f8fff85bca509617"
    sha256 cellar: :any,                 ventura:        "072350b3a98251b171b1c18e9db1e3bff11b1c77f2d103daabc43988f3702851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebbfb6c43c17adb414efeec24584f41b42e05b90948b93596f3cf50913aa100d"
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
