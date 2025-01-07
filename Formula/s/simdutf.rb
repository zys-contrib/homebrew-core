class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v6.0.2.tar.gz"
  sha256 "2d31db5794fe1d508e0104f32e65dad5570cf7ee280d3ecd09bb4ed8a4e4579c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "044b4e210e4cb0a559577e9e73296cd2d7b6503aad682992034428fe2f978c10"
    sha256 cellar: :any, arm64_sonoma:  "cd1e47574ae7fd8229ff2ffaec74f3665163ba882a0c3812e7a82d85b43fa864"
    sha256 cellar: :any, arm64_ventura: "c0267508d51a80b99d56f94b287e0ade87de0a5fdd8c488010805eb01b9b2e3c"
    sha256 cellar: :any, sonoma:        "64c0ea8d67dc6d5fc0226b61f3fc636b5e5c73197790a25d8b8083a7f68e97bb"
    sha256 cellar: :any, ventura:       "75ffd567f616c4ce0fc775bc09f651c1a11142c4019cb2c62736b456cd5470b1"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@76"
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  # VERSION=#{version} && curl -s https://raw.githubusercontent.com/simdutf/simdutf/v$VERSION/benchmarks/base64/CMakeLists.txt | grep -C 1 'VERSION'
  resource "base64" do
    url "https://github.com/aklomp/base64/archive/refs/tags/v0.5.2.tar.gz"
    sha256 "723a0f9f4cf44cf79e97bcc315ec8f85e52eb104c8882942c3f2fba95acc080d"
  end

  def install
    (buildpath/"base64").install resource("base64")

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DFETCHCONTENT_SOURCE_DIR_BASE64=#{buildpath}/base64
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end
