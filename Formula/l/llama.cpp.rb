class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3703",
      revision: "19f4a7b296efda7c13a6b21d428b2286b5d1aa06"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9061baa2a900579c9c9f494ecdd4078bc188a46841590f8e9b71ddfe8a33dd01"
    sha256 cellar: :any,                 arm64_ventura:  "920c24c2f0602069fdba18b7402b66e316f4e62f09b17ee0dd568ae2dcbfa38f"
    sha256 cellar: :any,                 arm64_monterey: "402d42e495b02945ae30705927b93063224f67159ca22ff55b22bc8ff30e3d2e"
    sha256 cellar: :any,                 sonoma:         "4fe2362bab9e0b19c5739b944aefa694a084fb846c37115e134e9bb73190e2b6"
    sha256 cellar: :any,                 ventura:        "d3dd8819e215c02a7bfe90d54e7cb1a38def49b7382f5938d62151a53c7f617b"
    sha256 cellar: :any,                 monterey:       "5876ff3ab6b52ef8d0e08d23ffdd7a3a53aae9ff8df9cd7a2c059ceae7277190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b349fa5594b39d3610e8dcc57180c22ac0114f23003fe1470f84a8f7f76f5638"
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
