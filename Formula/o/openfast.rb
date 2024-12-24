class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https://openfast.readthedocs.io"
  url "https://github.com/openfast/openfast.git",
      tag:      "v4.0.0",
      revision: "da685d4997fd17ea845812c785325efa72edcf47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8a72a85dbff83d23d14d233cae5b4150671b388906468aac72f057c921a40444"
    sha256 cellar: :any,                 arm64_sonoma:  "5cb454a6ff547ca213af905a82b60ae0c53bc15bfdf3c18ca1e2ecee287339c2"
    sha256 cellar: :any,                 arm64_ventura: "e2e86e68c2989ffbfa297d88872fdda7c1087e76c8fa87cf7b8ff8df032030a5"
    sha256 cellar: :any,                 sonoma:        "ed061e7af5ed1d7c37fcbe175a83d423a5ef68e746d1cd85a31983ea9342370e"
    sha256 cellar: :any,                 ventura:       "ca645a3c5f01606ad21253ea7f7ccb4fe60b72f392bde4d5f5fbc344283cfe7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "895ca9cbad2586ae82aa5d2e44dc6a09086cb914e50218a4b2fe279fdf353141"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "netcdf"
  depends_on "openblas"

  def install
    args = %w[
      -DDOUBLE_PRECISION=OFF
      -DBLA_VENDOR=OpenBLAS
    ]

    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", ".", "--target", "openfast"
    bin.install "glue-codes/openfast/openfast"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfast -h")
  end
end
