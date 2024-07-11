class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "9b568d6e66b14810bdbcf645f19b103475ab8175201b5c85828222c0ff0a735c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "88e01c7d1d6e13554c0a0b1402fb2725af01989b48562b1132b8872fa0cafe93"
    sha256 cellar: :any, arm64_ventura:  "7af24734a478f1f412e63c6f1f2b1ed9237472d007db2c132b4a33fe64055338"
    sha256 cellar: :any, arm64_monterey: "c60db767114e135842c8aabf15e356d814fdab89cf1c188d98bc315d4a3dd785"
    sha256 cellar: :any, sonoma:         "f65c3304820ca11fd6ca601b1834d615ef6f2df8e64caee6d8ac7b18e2f478d1"
    sha256 cellar: :any, ventura:        "c88fe1cf89b912243d3213fdf1abe66decd747237c9120fc5750d65a72c88b20"
    sha256 cellar: :any, monterey:       "6e093a7e2de161fa8fba90d187fc3edfc4e0051d22d4f9df534c0b0925961478"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  # VERSION=#{version} && curl -s https://raw.githubusercontent.com/simdutf/simdutf/v$VERSION/benchmarks/base64/CMakeLists.txt | grep -C 1 'name = "VERSION"'
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
