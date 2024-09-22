class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3804",
      revision: "c35e586ea57221844442c65a1172498c54971cb0"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd73739d1144d2ab7c67f136dce79cf02b3f4d04472b719097c5ba7657562aa2"
    sha256 cellar: :any,                 arm64_sonoma:  "b15a3d8e8c8667a014305ba58f48823ba553899e8409cd082bb959c413ffea2a"
    sha256 cellar: :any,                 arm64_ventura: "85f4835648bb9bc940df30e3f4b2a851fe5e91e977a5307d94934911a509eaf4"
    sha256 cellar: :any,                 sonoma:        "5da69192e6fc267e1fb9ad446b36b3e19acf783a9a1b70dd3e2ff62bf208b9a5"
    sha256 cellar: :any,                 ventura:       "07fa64a1d02410a15fdc01587a72079ab918a0152e543d86b724d35909331edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59ea9ec548da7547523be0c5589467632ef246a8d4865ff26cb03d7ff852afad"
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
