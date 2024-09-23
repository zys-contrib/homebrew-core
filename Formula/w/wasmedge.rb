class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  license "Apache-2.0"
  revision 2
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  stable do
    url "https://github.com/WasmEdge/WasmEdge/releases/download/0.14.0/WasmEdge-0.14.0-src.tar.gz"
    sha256 "3fc518c172329d128ab41671b86e3de0544bcaacdec9c9b47bfc4ce8b421dfd5"

    # fmt 11 compat
    patch do
      url "https://github.com/WasmEdge/WasmEdge/commit/3fda0d46a8fee41cc77eddd8a49ca3f423cf7d95.patch?full_index=1"
      sha256 "23f5555ffebed864796922376004ae5c3a95043921e2e6dae5f8fb6ac9789439"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c6da772877caa84c519af7fa9be3b8211b870c586fc581373d5cde8f01510d80"
    sha256 cellar: :any,                 arm64_sonoma:  "70bd5c8d863341572a7faaed1f18f50976cbb3685cf554b8a6da6e36f160f23d"
    sha256 cellar: :any,                 arm64_ventura: "d3c1e895a98f3723b9b152ba1c03e4ede5933b675d344ed29c56ee3adea2a829"
    sha256 cellar: :any,                 sonoma:        "c7732965f2f8bd4f6ecde1de586f6e5462125cb860857af30cb3360b716da80b"
    sha256 cellar: :any,                 ventura:       "244493be030ecac9ed0d5121e84db174699edadbc1bda050bef9a450b8478e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aa7e1095343cad4b0608bc8981dd0cc8cfa4b045c352f80c30dfeff7f29ac96"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "llvm"
  depends_on "spdlog"

  uses_from_macos "zlib"

  on_linux do
    depends_on "zstd"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # sum.wasm was taken from wasmer.rb
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmedge --reactor #{testpath/"sum.wasm"} sum 1 2")
  end
end
