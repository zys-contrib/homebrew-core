class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "a50ac5644b1b8d594338ab7579d824a91c5640ee0fb1f33e00513f98926b091f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0fd7fdfa03e21d6cc7c9a91663b5da4008a032a4daebb4dd7ebf2aed3e4eee41"
    sha256 cellar: :any,                 arm64_sonoma:  "abe52c3805dfb05250f0dbc6f47d71f18db8bc7a0993f410c2946b24b813a6eb"
    sha256 cellar: :any,                 arm64_ventura: "f9f269b37c4941df394f3557a7633ebe17f8bee17542e690f79ae82a79c7ffdc"
    sha256 cellar: :any,                 sonoma:        "70786320c841af6a27bb0dc0dd2a14ccd7e6c62d9e1db5817fec0815b7b31b35"
    sha256 cellar: :any,                 ventura:       "560ed598cdb96b8b9eb755a04467225e5a0fa54ae9a90651e4e827779a402aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa481d355cd75f6cc2aad13dddea843ffe5bb1a99cf2a5f93169b76734689204"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  # fix narrowing conversion error, upstream pr ref, https://github.com/yahoojapan/NGT/pull/177
  patch do
    url "https://github.com/yahoojapan/NGT/commit/16077296a104e33cee160cce53398805a560a5e4.patch?full_index=1"
    sha256 "b7a98a89769430cf2c9122c6c3a560b041f35498b08e10eddfd3497f2c189550"
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
