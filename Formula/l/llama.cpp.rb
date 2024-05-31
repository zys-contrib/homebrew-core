class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3056",
      revision: "0c27e6f62eea80140daf152d7b6c154466614e5c"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "67c993343be3e7216a70a47c013aca44f4ea47ca4ef98367667c5074e505c8d4"
    sha256 cellar: :any,                 arm64_ventura:  "5a46d66148eafdae111fb81e82371af477df59c9ce7f7dbc86d7557539d9fc71"
    sha256 cellar: :any,                 arm64_monterey: "6f84312fc93cc79bdbb671e1d36e37d763ff6ef3678d1763f765fae13df5c73d"
    sha256 cellar: :any,                 sonoma:         "dca1cccd9ded836e42ea3e9b73c6082bc756adceacd61e1a1db58b7bcc13cfb9"
    sha256 cellar: :any,                 ventura:        "63d1ae147733222e7618bc5db6cac43cf2b9962987624e382addb82885c2019f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30736f9ba04f6872d7bbe0bfb52d510ff389f7cd4a4fe6ae766dd9e2dec8f1d1"
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
