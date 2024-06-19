class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3180",
      revision: "91c188d6c296bd3384f2a02a83b71187aa3d18b3"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "15d8598f012aad0e8a57f8d910672d21e195b6f7185e01c62d9aae169e6f2f86"
    sha256 cellar: :any,                 arm64_ventura:  "a94ac03cfe6256b3e4f952332a1420b90f13161bff75e9e73d0be08273b7ef16"
    sha256 cellar: :any,                 arm64_monterey: "0618838d5a6c361a102971c63e7f8969926ab421cb00fb3765526239f74c76c0"
    sha256 cellar: :any,                 sonoma:         "8897161b0d5dabfbcd6b3ad1ae61cdeccec63e79a457213bc4113bfdc66364d2"
    sha256 cellar: :any,                 ventura:        "fe817315323d1a72604502f29243bd27902f35427fd30f5946f31044510fc0af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a377ed721163c52a11484e13d71bec91305b746524ee7bc8b0f16f5031b292e"
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
