class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3075",
      revision: "3d7ebf63123b8652fb7bbecef7ba731202309901"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d734997f765151ac2140b66df4280fe2f8e27234d547c9e91aec65ddf917a0ac"
    sha256 cellar: :any,                 arm64_ventura:  "e1642e90e12a5e14d6077851d755369fdfcc00ecd8da0f61eedf13a06156e87e"
    sha256 cellar: :any,                 arm64_monterey: "1bf487157901f5ea8e6cc5f0eb4cf0993ce283c837dda887d62e9fd416beaf26"
    sha256 cellar: :any,                 sonoma:         "07167336d3222409dcc84e24bb9ffa6571e46a7749d41782ee285f75f3c09a2a"
    sha256 cellar: :any,                 ventura:        "478f0b310a72dd9d2f6a0e8cb3c1bf7cd60a29c5bd9b64bdbbbd0113ae48a109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aec11283ab5a94badbc898c6794780a35517a26dd2fccc27140c80502fc0f0df"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
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
    libexec.children.each do |file|
      next unless file.executable?

      new_name = if file.basename.to_s == "main"
        "llama"
      else
        "llama-#{file.basename}"
      end

      bin.install_symlink file => new_name
    end
  end

  test do
    system bin/"llama", "--hf-repo", "ggml-org/tiny-llamas",
                        "-m", "stories260K.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end
