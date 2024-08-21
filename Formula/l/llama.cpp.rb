class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3608",
      revision: "50addec9a532a6518146ab837a85504850627316"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "54407105574e8147e976da452d67999c9c10134dd2c33d895b14b366fd682cd1"
    sha256 cellar: :any,                 arm64_ventura:  "64eb6bb3aaf56b3714a64dc92791c7e4c5d97f945d1b519175d08358c244cdce"
    sha256 cellar: :any,                 arm64_monterey: "af7b1d6b54d55f40557f62017ed2aea1131603ad7bd998cbbc5cece1754740c2"
    sha256 cellar: :any,                 sonoma:         "871596cd2d28c09179a566d666beb4ec8c4a91f35c67930bc6dec70463dd0f15"
    sha256 cellar: :any,                 ventura:        "f18b5bdb73861df147b5710d55d40760006894dd4c2b233537ad01153b55f313"
    sha256 cellar: :any,                 monterey:       "a6b7e0f7655fb9308ccdc4ded78023f6acc5e17876a015d116569af0208b2304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93dc123e0063c454f26263486f5273dddab2d7a73a69a461e62c145f42494afd"
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
