class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://c2rust.com/"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "912c28e5e289d1a9ef1e0f6c89db97eba19eda58625ca8bdc5b513fdb3c19ba4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d03fdb5423d27527055e3b32b9508f36c9193fbf86281940067905cbab84d97e"
    sha256 cellar: :any,                 arm64_ventura:  "11522bd88ff17a7981e7ce5a74e3dde0c442e6e5e37d1b2497fafafa32590ecb"
    sha256 cellar: :any,                 arm64_monterey: "59b1164ade2b95e8127d08da578babd61e9f4a8e91512cfcc67ada96f0c6c251"
    sha256 cellar: :any,                 sonoma:         "a701e0ef919ea7b778e22394fefdc871afb9147e2b4d857d2c1a033547953580"
    sha256 cellar: :any,                 ventura:        "bf993f3a873054447c046da901ee70fe6dbac3862f46bd4a61b9d24a26533b05"
    sha256 cellar: :any,                 monterey:       "5e461e4891dbaae333391d924b52fef6a67d280a22da2aaf315ba747203100e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38a3389cdb64ceca21ffa56b9d41c901ac924cff6978b275d3c6d37fe3cce2f7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args(path: "c2rust")
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/qsort/.", testpath
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
    system "cmake", "--build", "build"
    system bin/"c2rust", "transpile", "build/compile_commands.json"
    assert_predicate testpath/"qsort.c", :exist?
  end
end
