class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3083",
      revision: "adc9ff384121f4d550d28638a646b336d051bf42"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "79dec3da2e11301e1c51f05245d2fa7dcf07b1e4ff7315471072b7fcdd068791"
    sha256 cellar: :any,                 arm64_ventura:  "e22950d7116467936d1fb95c77024433a142fcfc5ee141998eddfe85da8277f4"
    sha256 cellar: :any,                 arm64_monterey: "f9981e0eac5dfc470ff63cb452a885d856fbe1dcc9ff3ea4d9983f331bb9a7cf"
    sha256 cellar: :any,                 sonoma:         "ffe192ea1977af304577227af7689391afd4ca1a1cb12fd021db1cd70cd7240e"
    sha256 cellar: :any,                 ventura:        "7846cc1471245132d73b65faabf7d9750adb7b867a75aa79e72e9dd5747b3785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dcf2df4fc20b1b15a6c1992722603fd18450c621e2b01199d53e267a87227ae"
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
