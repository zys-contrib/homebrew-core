class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3187",
      revision: "2075a66a96cc1b04eabec7cf4b3051193d6f719e"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5bb7eb3a8a00e89c87057e1d63d3c7d4c3d030dadad558777317103c036a4612"
    sha256 cellar: :any,                 arm64_ventura:  "e3c663080e7650dd611eb19c36c08f49f43bbbbc9468e1472bd1c47044ababe2"
    sha256 cellar: :any,                 arm64_monterey: "b53b0c5e65700242a266122322ba44eb036cb52ad858bd68aec5bec7c178279a"
    sha256 cellar: :any,                 sonoma:         "7f0f860d6500576c81a39effe9d1f37c2eb9bc4534cd131e6ad954c282079fc6"
    sha256 cellar: :any,                 ventura:        "8b5a88ec2ed29913aa264d1cb846f489b9305346f76c3fd88c87774a9a283328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af9135071247c71437d05094c48c7b52e3f18afb0887d83fc9541ed4f8072533"
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
