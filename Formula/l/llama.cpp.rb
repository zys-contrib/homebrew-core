class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3384",
      revision: "4e24cffd8cccd653634e24ee461c252bd77b1426"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "761892c7e807da25fef91a53bb9515c09d4a788d930167283d3b8341e215aa0a"
    sha256 cellar: :any,                 arm64_ventura:  "88f98f099e1f4c182e42588ed95889895227178bd8b96c3caf2a3185c2e42971"
    sha256 cellar: :any,                 arm64_monterey: "bf86654f62caf3d41f6d36ea5e07c5657af6ef9de96fa6486a264dd6f2a7781f"
    sha256 cellar: :any,                 sonoma:         "8e5470ef6f7ef1a42ee7a1841b8ad5709ef1038db7a514e7b377b9da2e2f8ced"
    sha256 cellar: :any,                 ventura:        "40dad13210818186f25f042b2fe7cb86ba155ac51f8dc305be0bd2f077d06e51"
    sha256 cellar: :any,                 monterey:       "ff2d28e6366642f1448b87fe62d61245572a4c8472318f2bd49fdb7256b15253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc1bb92d207ca6b37e760fa6715d62d65c4842e14e4da367ddbb9fafede96a02"
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
