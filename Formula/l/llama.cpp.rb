class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3571",
      revision: "5ef07e25ac39e62297a67208c5bcced50835a2dd"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f9d2a39351870aeaa55f9f8eee06e8b181fa99d4036b9d8107c4f11310d4334"
    sha256 cellar: :any,                 arm64_ventura:  "35170f86b6446fa7f491866fc8f2c2b942c92199ce44f97a214d460418f2340b"
    sha256 cellar: :any,                 arm64_monterey: "6e5fbab864e96b6ceecb6237058a1d0fc4e47dc38af82d626dacf0b9dcd10ad1"
    sha256 cellar: :any,                 sonoma:         "921691b5979c18d25d0523524299bac5b0b8627ce4b018df108becf8532b603b"
    sha256 cellar: :any,                 ventura:        "47ed29af82eefc015666b765d3de8daf514c7b39930d340cd50ebfe4e0c38879"
    sha256 cellar: :any,                 monterey:       "34a6b91c25f4bd5f08ab661c4044bba0361d504c834f9d582ac06f5ad81003f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2065b238ff521766230b50be22eb894ef16bf5c0f114bcd94182a4e406ac89d"
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
