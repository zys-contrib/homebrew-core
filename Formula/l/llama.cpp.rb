class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3066",
      revision: "e141ce624af57bdffbaf57014a044eb1d9689230"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c7b1786258a273d0a5227562a0c6e7ef8783fb2d8799bbb047f3bd5f357195c9"
    sha256 cellar: :any,                 arm64_ventura:  "b0ff40e5385e0190e694056b59e70308ffe784dc8e075650523ba875abfea233"
    sha256 cellar: :any,                 arm64_monterey: "d1868dbb4d46354da313733aa452311100e1868e8a00bcb05c140fd8004ea5d9"
    sha256 cellar: :any,                 sonoma:         "cb2e75a95eaa923a506ece668bcca08a41a938ba62ed7ac8298467157ace662e"
    sha256 cellar: :any,                 ventura:        "8bb259b56f62765849508668a1a7b65ec3ccd7974c12e5bfe74949eee8b6bfcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "047ba3c9d4f767f858154a2600dc9e7388c97da9755fc3eed52764e89a30e3d0"
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
