class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.1.tar.gz"
  sha256 "882cd8473ad932b24787e676a808e4fb29c12e086d20bcbfbacc66c183094b5c"
  license "Zlib"
  revision 1

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eeb572e24c3e2aa9c3790cd5892849c85ac5761d5001514c78da09db7fe8c8e9"
    sha256 cellar: :any,                 arm64_sonoma:  "44a773082a9f0593e9ebf2248d495d365551ee3639d40141145827890a96f28b"
    sha256 cellar: :any,                 arm64_ventura: "1841cac9c12b759afaf24dc8cfaa3b9b484947ecdbf7309a99bca1c1cbef6a75"
    sha256 cellar: :any,                 sonoma:        "80356a61ac01a070654c250384e8b55366cf15294e28fe9a7f0773b0a1fac312"
    sha256 cellar: :any,                 ventura:       "7952caaab0773710a097a4004b8bd5e6c31848f75bd743eb67100e3e1c0ec586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b933e606270d4d4227c032e1b078b508288a4af7f423b9f6eced525f48696a"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.13"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/de/8216061897a67b2ffe302fd51aaa76bbf613001f01cd96e2416a4955dd2b/protobuf-6.30.1.tar.gz"
    sha256 "535fb4e44d0236893d5cf1263a0f706f1160b689a7ab962e9da8a9ce4050b780"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/81/ed/7101d53811fd359333583330ff976e5177c5e871ca8b909d1d6c30553aa3/setuptools-77.0.3.tar.gz"
    sha256 "583b361c8da8de57403743e756609670de6fb2345920e36dc5c2d914c319c945"
  end

  def install
    ENV.append_to_cflags "-DPB_ENABLE_MALLOC=1"
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-Dnanopb_PYTHON_INSTDIR_OVERRIDE=#{venv.site_packages}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    PROTO

    system Formula["protobuf"].bin/"protoc", "--proto_path=#{testpath}",
                                             "--plugin=#{bin}/protoc-gen-nanopb",
                                             "--nanopb_out=#{testpath}",
                                             testpath/"test.proto"
    assert_match "Test", (testpath/"test.pb.c").read
    assert_match "Test", (testpath/"test.pb.h").read
  end
end
