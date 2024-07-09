class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3354",
      revision: "5b0b8d8cfb5ddf2118f686ba6c30fab3f71b384b"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "321680940fdd62eac101a1701fdb5670be51189c2ee085e607c276f2cf2b7559"
    sha256 cellar: :any,                 arm64_ventura:  "3e72ba891517401c5af842264d84f0e553aa73a4282e73f69c737c8ad9051dda"
    sha256 cellar: :any,                 arm64_monterey: "371e95d79e8c61817bae6c2ca6266ce6a3b14f175e111d85c20c0fc3e5b89502"
    sha256 cellar: :any,                 sonoma:         "b4360607388039b71b1e232c128343ca32e57ab537492a74f2eb5317fc9bde41"
    sha256 cellar: :any,                 ventura:        "9f8b9334fe201bdaa18b128bf837386634c241515ae89cf68182f3a6866551d5"
    sha256 cellar: :any,                 monterey:       "dc8114b6e3872de855e56e8b5db754a7f77ad5483edd7956b5dc2e3727706e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c79f45b8cfcf74bc8fb2238591afb606f4eb4f8a746c23c28bf8adb224afe167"
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
