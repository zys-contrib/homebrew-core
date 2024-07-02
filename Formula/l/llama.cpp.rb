class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3280",
      revision: "0e0590adab9f367b15ae2bf090a6d24f9df47ff1"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef80310a006caf7237a8aa6188d9a84a37443cc8858ea645bb5efc235c48fb48"
    sha256 cellar: :any,                 arm64_ventura:  "7dcecf62441c377df1b696b2b0c32e2fd5133a6f469dc616028f57bdb09c9320"
    sha256 cellar: :any,                 arm64_monterey: "4b1707285ab5bc33f2ecc6bd03dceff405f90cb40a5c6ad990eb405215fafd88"
    sha256 cellar: :any,                 sonoma:         "8e558f7e74c3cf23705a482f119315a96375afd0699e72767d1325de69bf4e6d"
    sha256 cellar: :any,                 ventura:        "4a6f785b7a1853f0c3d664b77d343aabc17f8b1b330f147e2a7703f370e34144"
    sha256 cellar: :any,                 monterey:       "0c6a8c600621e300907ca27bd5695141004ad87cae263fc116367ec288f0edb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83a2e90389185af7232f8fc00896b74febd1c339594e3ac92796e5e8b43e8455"
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
