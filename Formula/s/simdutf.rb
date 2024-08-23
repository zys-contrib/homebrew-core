class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v5.4.14.tar.gz"
  sha256 "386bf103c0c61a7c1703f273227c0363c927d9b74c43c1ea63ea59b4e9c33516"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "977cc3028fe0e26ec02b9079998b68a79f2b9ceca935c1972729fb31d61a8555"
    sha256 cellar: :any, arm64_ventura:  "6586f1319d7d0b915a13b16efb22aff4d8d65ef68e371e8de387cbd187357d39"
    sha256 cellar: :any, arm64_monterey: "dce95af45ab328a3143a56266c723653568f18518682e5c33ef9836262974204"
    sha256 cellar: :any, sonoma:         "773074dd37782220a0d9dc3d3ed46f924c8ca31abdffbf653b79053513a14344"
    sha256 cellar: :any, ventura:        "f62a3144b5a9800d4ee96ace80b1bc4f4c6af38aa71d2da9ee24230bca1adbc6"
    sha256 cellar: :any, monterey:       "a98feecf250c7ecb07c80f56755dc1d51e3ee389acce14f43981e1a5f90826d8"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
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
