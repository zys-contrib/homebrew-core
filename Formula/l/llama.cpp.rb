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
    sha256 cellar: :any,                 arm64_sequoia: "5993670ee9d9ec7610c7a8ef1c02775ce872230c66c69ed6ab6cf9fd7cc22c8e"
    sha256 cellar: :any,                 arm64_sonoma:  "b66e11b46bbbbdaec009d065aeca926e1e731f02e9c95dd06c5c804d015036d9"
    sha256 cellar: :any,                 arm64_ventura: "4425182a2ec91bad185ca0c78ee5f8fac4687d82a9d45c7eafa709ca8a7e40e8"
    sha256 cellar: :any,                 sonoma:        "d05968398a5562ef2ee22f26ca4ee28163ff54a81140a4e29ac225f245b0b816"
    sha256 cellar: :any,                 ventura:       "b797eaa9a6868cf51d23221a7859be05ec1a98c2e2cdcf281f0e8924951de3e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "177ac9646ac67d94d91aa3ea14b4bab9b5ff285b23b1076f710c9d007bb83438"
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
