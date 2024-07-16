class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3403",
      revision: "37b12f92ab696d70f9a65d7447ce721b094fb32e"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "be841ad41ae099407a2e7a3cad9693748c3357c937a008d85a2747245759b29f"
    sha256 cellar: :any,                 arm64_ventura:  "678af371c0f79b0e7f29b47d006051d688a60ab886af97f58b29e1f2b58def82"
    sha256 cellar: :any,                 arm64_monterey: "cea42c62fbfdd1f9b6e51b71b738d9e1e1c7622ccca1b9aa0ab344ebc289df2d"
    sha256 cellar: :any,                 sonoma:         "8ade648d501f66d0683245b34637c84b290d03662a9c638879de2f32491c5a7d"
    sha256 cellar: :any,                 ventura:        "b544e330223becbf4fc12b8c213d336f8cd97d88dafa3e596d1b7ff1ab387b1b"
    sha256 cellar: :any,                 monterey:       "461a72b534625bf1e44a503fc0612f02636dd4461e89c270c4eff6c42d47bfec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab791dd64a6bf703fab4d13103a62429c725553a5ce840b544be9b80ac76c8c3"
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
