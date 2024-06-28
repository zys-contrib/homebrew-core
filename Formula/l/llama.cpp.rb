class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3259",
      revision: "e57dc62057d41211ac018056c19c02cd544694df"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "61a7448d8eaf39a845910eca4adae7141db176e593218abc4b9a2e6a9321452d"
    sha256 cellar: :any,                 arm64_ventura:  "5aa48c46864ee14573c444dd6e4e15a01a69335f6ace9c2a663f3c037e447a81"
    sha256 cellar: :any,                 arm64_monterey: "20c3b5862286e355d34539ac33f718053926b2ffdd843e5183ca59d2a43b2965"
    sha256 cellar: :any,                 sonoma:         "fdeaa2731e222d57d9093f9dcf90c103ec3efe4d12cc34003160c0cb0e53f436"
    sha256 cellar: :any,                 ventura:        "5608323a119de22f7006dbc3538807f38c854ebb776e2163e829bc49ff6e61b0"
    sha256 cellar: :any,                 monterey:       "f6272dc23922f0d45768174f2aa5fc9b7b733929990264d1a3ba7fada1c0eedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58f3d2773de113ebcfd98191f8a71a29b761554b7072ef51330b7300b5cf5dbf"
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
