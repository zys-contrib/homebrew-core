class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3233",
      revision: "494165f3b6c4cbcd793123cb57fb3e1f5477f1db"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3af1d4d09e41d4429344f09ee204808d215e979c2d2ccb664effef79f1195d95"
    sha256 cellar: :any,                 arm64_ventura:  "31af350b6c8a0788c2a415480cf4db2c07916cfb3d1c95415b69c508d0b1a951"
    sha256 cellar: :any,                 arm64_monterey: "886ed359a29f22515d54b1ad91b8f09df34037bbec2e2ed3a7d5fabf9554d310"
    sha256 cellar: :any,                 sonoma:         "ba19ae9836362985ba920a32f8d774522d2ab74624a579e2638c948a96fbb8ea"
    sha256 cellar: :any,                 ventura:        "57b0700bc0d58f8ef1e4ec6b630a7a7e8ffcd885f5e8ead082f73b2c4ee18e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85b95337d96caa11e1f279a01e696989628b7f61fba967a607ea0b410ae3740e"
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
