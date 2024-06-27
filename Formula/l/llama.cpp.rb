class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3246",
      revision: "ac146628e47451c531a3c7e62e6a973a2bb467a0"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "adf5153b94189137741a4ab29e68a36c87b86d387f825f01af4931d7af03f9c5"
    sha256 cellar: :any,                 arm64_ventura:  "fc88fdd784bba5939f542562246b6bc6edcbf4c42860c9955eaa166433a51eae"
    sha256 cellar: :any,                 arm64_monterey: "9d03d799aea0c5c292b61e628b64bf15b7550045a0fe0c92bd22b8929d9725fa"
    sha256 cellar: :any,                 sonoma:         "3511be5b16037349d747b9fb83ce89f13b67321aabf58d2e480471c2ad1f6262"
    sha256 cellar: :any,                 ventura:        "2d4f860e6ebcb66ab18666ce311169d6774c5e82842b67fe7eb63fa3f424ca06"
    sha256 cellar: :any,                 monterey:       "9ba158997ddd9db4112e57c8f604f2126d571781ed846efbb757409e0344a768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89e5921f067647678c6ee451c7114b0555499ba640a7b8944e84cd603082d877"
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
