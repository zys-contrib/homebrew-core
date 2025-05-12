class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b5360",
      revision: "f0d46ef15717cd609a7b69cf6190edde64d466c8"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a7105f6407b4599d26fdc693095d3b56d860107bc1a419de4af1cc053b5b10a"
    sha256 cellar: :any,                 arm64_sonoma:  "61ba5c3db1b864459bd58220e915fe160f226475ce9494ac70759ef527f6f203"
    sha256 cellar: :any,                 arm64_ventura: "681cd640cc3beb7ebb7b8acdd126dbf621f33d386c3859a4e7f8f5be7b9bd85b"
    sha256 cellar: :any,                 sonoma:        "d7c042cdb366d45c0f4f6b2e48fd152f3a89739dcfad1b51dffbbd57130dcde5"
    sha256 cellar: :any,                 ventura:       "cd5a46cff6fe1ec382887cc030b5b7fd323db976d7d93d01fcdabceaf89cf3d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11ec431ddc8e395f4617ed9ccae025aad21bc8e7c33544c77c9a9539ba36aa0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed747e51bb73459a6392e4635134828d6642e2bb63508f21ace0d3f5544cadee"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_CURL=ON
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
