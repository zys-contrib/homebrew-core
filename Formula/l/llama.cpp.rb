class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3358",
      revision: "a59f8fdc85e1119d470d8766e29617962549d993"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e4bda03a5efbd33b4b6a69d48b4471e8bbd00ba9332ca8d029a7620a4db382bd"
    sha256 cellar: :any,                 arm64_ventura:  "de450ce4af9628d8deef462763556f9cda3a2d296a49195d726a4a6eee91ccee"
    sha256 cellar: :any,                 arm64_monterey: "873f1da006db15ba3e09f1e62f5a0e31caba30ffa5d3b56dfcb9422bff87e63d"
    sha256 cellar: :any,                 sonoma:         "7dfa1c270a47799b32aec82fe42301706a2e30cedba93e694fb8bc03633497b1"
    sha256 cellar: :any,                 ventura:        "179ec445c1f128f0b83cf0df73f8247334d9dbe6c125c7679ded44be5f681776"
    sha256 cellar: :any,                 monterey:       "8b09e3d0f93a7019b6c48b469afab26ce6ea738daa941e4b6a88ec55a6199315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd0373e415f73599a80d571e69a52b12cf04caa55cb6a74c05f9365753455c5"
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
