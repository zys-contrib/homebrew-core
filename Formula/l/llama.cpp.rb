class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3661",
      revision: "8962422b1c6f9b8b15f5aeaea42600bcc2d44177"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d9f6fea58a3f41eb8fffac2006af0e7ee14899986b41a88acfe0121d2a5f6a14"
    sha256 cellar: :any,                 arm64_ventura:  "8c1131e202d41c47870db498edbfa419d9fc50a9ae37bebe9d5b6417b510fc94"
    sha256 cellar: :any,                 arm64_monterey: "8dd408be981fb47e9e31a86a7780221b4513f83fdcd43efd9ca3bc7b69c628a5"
    sha256 cellar: :any,                 sonoma:         "2a806ff6ad1a9d933c05d295606dc7ce6cb3d89b96272f99e8d2bc30a8e392af"
    sha256 cellar: :any,                 ventura:        "15209eef894eb1e0f8b9408c5c8e08e1add4415c1b81949689784e0ec70c1a63"
    sha256 cellar: :any,                 monterey:       "f857baea32322f9aa08dfba7ea3e14eece41caa3ab3971d8d769f30351cc5592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a396530829fae1bdd79db819c02d3768520e77d54a682386d217df9096b929ed"
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
