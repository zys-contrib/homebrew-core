class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b5330",
      revision: "17512a94d636c4b6c1332370acb3e5af3ca70918"
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
    sha256 cellar: :any,                 arm64_sequoia: "9a810fc79148d7ad4ddb1b4b2b9f36f44aaaf553fc39354ab62f8334ca9b9dda"
    sha256 cellar: :any,                 arm64_sonoma:  "4bc3931ff8e791fa336a0317501957b1c73b816e1f43e93cba31ac9b11c84b3b"
    sha256 cellar: :any,                 arm64_ventura: "3cdbc5162b259cbe84c19353b7bfec7ac4aaacfadda11c536a916de241e1fbb6"
    sha256 cellar: :any,                 sonoma:        "25ec7e92db857b51f13c229634f520465d2c49d8685637fd887768df8440be67"
    sha256 cellar: :any,                 ventura:       "93b049332afcdde3af9c19f32b259f83597a55a4a862962a9c52ac7fedc43445"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "192f778cbe0cfef7a16cbe42bc5b339bd107dd5ac355c83995019f04fe62411f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f408c287624f7b56809c9788ff4450a4cbf5115f18b9806886943f9ea4cde9b"
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
