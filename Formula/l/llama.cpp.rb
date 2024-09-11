class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3723",
      revision: "6cd4e034442f71718563e600070c2b6fc389e100"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "06a1300501db7b83f9fb7fd83d06f18ccf3d8ccc39fd160f54dafa963096829b"
    sha256 cellar: :any,                 arm64_ventura:  "206a221c5e3f7b2b65ade1dba29b16f78936f74daa686b6da8f8167b9ebccce2"
    sha256 cellar: :any,                 arm64_monterey: "995e9c1c73bcd0e1336947d1d2d1f827ae59192a150eeb256fb90668dfe0f02f"
    sha256 cellar: :any,                 sonoma:         "38a29ddac25c059f061bba220c1534a58da30e78d029275643980e5f9dd2e878"
    sha256 cellar: :any,                 ventura:        "d9d570797bf7f50de9e61f16ce8ce3ea0c2aa2ab8c3835f62fce4a8904bf9263"
    sha256 cellar: :any,                 monterey:       "3aa96aeb46041a1decaa842052f5102e730c3712c27073b81adb5bb7b3e4a802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa35c93efc44af30566c81bbc3ac412721cf76c1773c37f271f6d4c46ef9eb06"
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
