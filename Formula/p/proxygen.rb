class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.08.26.00/proxygen-v2024.08.26.00.tar.gz"
  sha256 "2649561465d968e3ca7a7bd4daf3873aded95f2924c382d42fe2c22ec442c477"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e06e971a566092706c31ef13b9115124274e2549c44390c07745dc4b6a3ff1ba"
    sha256 cellar: :any,                 arm64_ventura:  "b00c77aef6909c0fa4a36ed3e9a0279da223ce9389ba0a4275c167644b3f2cc3"
    sha256 cellar: :any,                 arm64_monterey: "1a3e8c1972f88680fef8bd4ee3efd48cfd505e2ca46c4fbd6cf543ffb315131e"
    sha256 cellar: :any,                 sonoma:         "88ce950b04a72216c4e4728bacbfcd5749f3120cf2c109b99c816654152886b7"
    sha256 cellar: :any,                 ventura:        "6bc061beb2602bab90cd14dae04c7a5ec4c207eff29d229f38d2f7f27ddfbcf0"
    sha256 cellar: :any,                 monterey:       "63cc3f6a5ffc09521f5c09fb55420aa39bddd225f0f72410db653d701dc5d98d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71dfd1727b74108719a10a874e315a553d8f9f5a3d4258e4b6b0cec7076cefc4"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "libsodium"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port
    pid = spawn(bin/"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end
