class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.3.9.tar.gz"
  sha256 "2b0dabe1216ba063068834bed144bd1e077c79a5f8d8e05f53d0df2818d762cd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fa11280b9bf6ab7846de985abe15351492d1eab745fa030924c74b978d827bcd"
    sha256 cellar: :any,                 arm64_sonoma:  "d3a23f8af52fe5f1b7bdb9119ae90ff2e8b743dbb1d96b71219e3ee16acb67e1"
    sha256 cellar: :any,                 arm64_ventura: "42a9db3b95e4a714d449934137636f3242a960b1f83ab9d580ec58c89b4115ad"
    sha256 cellar: :any,                 sonoma:        "a33d10587ace7e385ad88fb5d32b64e098529c24b426c12e8c739f45bf234f2b"
    sha256 cellar: :any,                 ventura:       "c7e42366de526f73036241eed5ee09ce72749f0a17cacad72321c9f9699aea69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "345c85234f61cba6e795cdf4a5defdc4fd7a01a7518f6ca8221d72f7db0b0a0d"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DNGT_BFLOAT_DISABLED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system bin/"ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
