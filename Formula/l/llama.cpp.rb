class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3751",
      revision: "feff4aa8461da7c432d144c11da4802e41fef3cf"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1d46781c176d967ebdbf0ba8c85623369a059e5c866c5f41425d34c3e5f6d89"
    sha256 cellar: :any,                 arm64_sonoma:  "07b5bc92188a367e8ccb3492c0cb9f2da7a88458e9f7f7ba377a08494838e8f0"
    sha256 cellar: :any,                 arm64_ventura: "81a6cee61262189c2910817b6143f7befa8dfc715bb52c3a9554fd214866441e"
    sha256 cellar: :any,                 sonoma:        "4bc78002934859bd77f5e61f9454ff7c7a53a8f6b907d01c4c475a801e18e934"
    sha256 cellar: :any,                 ventura:       "8ee9852c953aa1935ba1e810d828702585dfd7c1a874a1dbb1ff8d343b3d3df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f3b557b1e0fd50bd61990664c26604c7b246ed6deeb7b6ab7ed0e248fdf051"
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
