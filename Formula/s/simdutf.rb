class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v5.4.15.tar.gz"
  sha256 "188a9516ee208659cab9a1e5063c1b8385d63d171c2381e9ce18af97936d9879"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "154eab0d8320c4fd3159dd3f972c97acb9601a274541ed28163a57b516070341"
    sha256 cellar: :any, arm64_ventura:  "4f6dcffa110a05f4cd08d3d6705566f3055c4d48eff41e42e8335eef3a756361"
    sha256 cellar: :any, arm64_monterey: "6fb7668ae40d75860ba0613b4fb3c983a30956d038a7360f0f4862a1059283b1"
    sha256 cellar: :any, sonoma:         "2b66c13ed14e114d70afd19a069ceb07a85bf59f9754879b7f5313f5b4f514ff"
    sha256 cellar: :any, ventura:        "04f832cd3a93f9c95f6ee2322e8c707b5982dd6be940aed1428cdc36396ef6a9"
    sha256 cellar: :any, monterey:       "e56c359225da05e921dbc0d0fcc3a12c2b4cee35abd5aea4539f36223d02d487"
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
