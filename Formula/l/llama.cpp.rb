class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3639",
      revision: "20f1789dfb4e535d64ba2f523c64929e7891f428"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c552229c7cffb5db0bcff6cbf671f57ca6a54f0fcc6c90a9ff635e6ba3db9fda"
    sha256 cellar: :any,                 arm64_ventura:  "b4f692e7f4e1f3c0802251f797bf55690b0e01ac66f3b8a5588353f4c7cb1c01"
    sha256 cellar: :any,                 arm64_monterey: "26f172fa9f7a7e7814709ec5a370ee73d0a5329e91dac3abb88f52c1ea934847"
    sha256 cellar: :any,                 sonoma:         "b5e9b120648db38f99f764c89decd3cdada2ae49f41f45ea4d9fb57f988cf6b6"
    sha256 cellar: :any,                 ventura:        "1d18f74f2fa066475835c03532e85290d1433bff03e19cd38eea1df533d36611"
    sha256 cellar: :any,                 monterey:       "a6cf55b644a5db2bbe44a6a4de338140f90947a735fc1cf41eb0996acdfff34c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b44f06b13a4a789917127c38daf1936171c3898975ea97441ad61d645c26167"
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
