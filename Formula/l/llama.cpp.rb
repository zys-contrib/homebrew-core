class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3802",
      revision: "a5b57b08ce1998f7046df75324e86b9e2561c7af"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8a27ab7743279ad7cc1f96a2d76e928885c85b7ea80058d54162d5d1a62eb44f"
    sha256 cellar: :any,                 arm64_sonoma:  "db91a80a953a8be7c2ab37ab50455c2172866acc896984b9fd9c4998becdf353"
    sha256 cellar: :any,                 arm64_ventura: "38bd034d64e39815e6e247398cd40adfa24325b581e0d96323bf5bc40d22601f"
    sha256 cellar: :any,                 sonoma:        "44d387e6d20ac6ab1d3f25b0919b5024ac271cdf54ecbd5f321498f493d9a195"
    sha256 cellar: :any,                 ventura:       "55c3af1e0568b693479c253d0814ec3e5317b6476f3cd76459a068345ec45d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1ea46bc3cd0c8fc78d9a3cee3b9aa2325c431d4a1786d1cb04d7903e9d68560"
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
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
