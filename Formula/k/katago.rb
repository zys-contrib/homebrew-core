class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  url "https://github.com/lightvector/KataGo/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "96a1ef3d12eb30a950164f203b012b5f2257ef796b9bd15163d9ba3b79a32a1b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd799d8af6382c749addb08572596e375b12b38292628e5d84e33beadf2a4b7e"
    sha256 cellar: :any,                 arm64_ventura:  "4a3e4976313381eef75470392601b7b11ade9b1ea7b27be0a1fec6256fbf0aa5"
    sha256 cellar: :any,                 arm64_monterey: "882062014dc33837070905e3c80c89cfa09723748e70d91cf00cf60445823268"
    sha256 cellar: :any,                 sonoma:         "99aa02a00d877b18aa253eea5ac5d838a3e8bab96bc9d940bfcae70a7dc1c22b"
    sha256 cellar: :any,                 ventura:        "8c6f3da9c881b5539b39bf0926a371e91fbce3a27dc328633be8a17119415f6b"
    sha256 cellar: :any,                 monterey:       "5f73fb232ac7196d0bb93cc600bbc91c1f374e5eef269ce9a74e75bbbbe5bc9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd528014652a59d84cc03acdbca5829fa83b4bac46609c032acceb6b688ebd78"
  end

  depends_on "cmake" => :build
  depends_on "libzip"
  depends_on macos: :mojave

  uses_from_macos "zlib"

  on_linux do
    depends_on "eigen" => :build
  end

  resource "20b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170e-b20c256x2-s5303129600-d1228401921.bin.gz", using: :nounzip
    sha256 "7c8a84ed9ee737e9c7e741a08bf242d63db37b648e7f64942f3a8b1b5101e7c2"
  end

  resource "30b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170-b30c320x2-s4824661760-d1229536699.bin.gz", using: :nounzip
    sha256 "1e601446c870228932d44c8ad25fd527cb7dbf0cf13c3536f5c37cff1993fee6"
  end

  resource "40b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170-b40c256x2-s5095420928-d1229425124.bin.gz", using: :nounzip
    sha256 "2b3a78981d2b6b5fae1cf8972e01bf3e48d2b291bc5e52ef41c9b65c53d59a71"
  end

  def install
    args = ["-DNO_GIT_REVISION=1"]
    args += if OS.mac?
      ["-DUSE_BACKEND=OPENCL", "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}"]
    else
      ["-DUSE_BACKEND=EIGEN"]
    end

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/katago"

    pkgshare.install "cpp/configs"
    pkgshare.install resource("20b-network")
    pkgshare.install resource("30b-network")
    pkgshare.install resource("40b-network")
  end

  test do
    system bin/"katago", "version"
    assert_match(/All tests passed$/, shell_output("#{bin}/katago runtests").strip)
  end
end
