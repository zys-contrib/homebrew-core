class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3512",
      revision: "c02b0a8a4dee489b29073f25a27ed6e5628e86e1"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e70e4172e33ad87bfcf38db6e7af54ea201ae98ba0ee5f876baedc405bd577ef"
    sha256 cellar: :any,                 arm64_ventura:  "c6a08e62504ccc363e1a39e561bd184a89379876cd57f4d4e88d27782d542b86"
    sha256 cellar: :any,                 arm64_monterey: "5d606d7fe8c2649f353195055e099d53aebd2edda253b789df42d2e901f6d8b9"
    sha256 cellar: :any,                 sonoma:         "a7c53d2bd16abf3eaa9d7a665968153cfdafeb5ffb8f41e144244308372d7a20"
    sha256 cellar: :any,                 ventura:        "36372d7fd409c29347bfe0883d726829ca8853f1e037ed20b79ba94183d8d56a"
    sha256 cellar: :any,                 monterey:       "60c6c47bcdfaeb8ec6468e694cef6177beb8ab0909d6b8da1eba76d749bae794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ce460b426f0cd00d2b740b90e6432b8f2b0e031fcf45e0f98fd4a6fec14aa63"
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
