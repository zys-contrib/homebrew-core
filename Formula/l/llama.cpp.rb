class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b4827",
      revision: "fa31c438e0e709242ab7334d26fc3be3dcda07a0"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca44eb18c4aedc3326d551bd9d823cef31c3feb691d1775ca13e7e3a07be9d5c"
    sha256 cellar: :any,                 arm64_sonoma:  "2fefa9a9ec6e0183b3edc2c2a558e6cbc6a42deba68886f597b88f72513ea643"
    sha256 cellar: :any,                 arm64_ventura: "59d6c9b59045c7bc435c9aa5f81a0cabf21a62d42a5f77035443873028800d85"
    sha256 cellar: :any,                 sonoma:        "e8ffba1810a575361d6d7d9e1c0fd4e9ee24c9bcf7be0e20f9aecd8754850931"
    sha256 cellar: :any,                 ventura:       "e9777b6c6ea2b32ce6cfb3eaf51f40ead3a1f0f25055996e1313dd38caa3a5e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ad1a77ff3dc6ea67644f20506793a944c1a7c98bb135ef5bc3ef1f0d599ea60"
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
