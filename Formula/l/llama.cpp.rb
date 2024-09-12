class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3747",
      revision: "e6b7801bd189d102d901d3e72035611a25456ef1"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0859d1f4b5b25e96917461e6ab3b229879223c15b663f75facd90b8df010e8ce"
    sha256 cellar: :any,                 arm64_ventura:  "452a9b55263919b74681c4dcbdd866127d54e54f95a90b5e2d957627a70e16c0"
    sha256 cellar: :any,                 arm64_monterey: "75070ec894ae004ec5fca4df083976fa675094d9d086b683ff8f9e79f5f7df51"
    sha256 cellar: :any,                 sonoma:         "84979152fe7576ba1e382bd5ae76db69ed1a0422f75b13e3755950191d7a6b11"
    sha256 cellar: :any,                 ventura:        "7b981ff5922e07db1624c65fbbd45c5a8cc74b2a15362586e661b4b5d129dd53"
    sha256 cellar: :any,                 monterey:       "fcc90df535b894883935bb35db9a6bb27bfd9b7cf083c25697091be097c7c3c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd0bfc81caddefd5a47312a4c8bad207996e61a4856b67cdfc1ba2bd527d2432"
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
