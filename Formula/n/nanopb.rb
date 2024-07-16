class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.8.tar.gz"
  sha256 "d685e05fc6e56fd7e4e3cacc71f45bd91d90c0455257603ed98a39d2b0f1dd4b"
  license "Zlib"
  revision 2

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "62e0b9c475c186ab90b505daeedcf9365c84730d060211875bf648c0d73c028a"
    sha256 cellar: :any,                 arm64_ventura:  "1e69abbfcecdcc7cb5645604979f17e4a2d1e95000c41f75cda72ae33b40d8fc"
    sha256 cellar: :any,                 arm64_monterey: "6c291614713d8ad370e843d6cd5e292ab24f9b01d4c26580db5452a8ec51962a"
    sha256 cellar: :any,                 sonoma:         "c7003e2cce28ef12d823d269a6a45cb126e589d8144fcc8309a1c78f84491f08"
    sha256 cellar: :any,                 ventura:        "c1ece4451d6abc7e1fa29854608b02d7215431ce6797dfb4a2f63da448d0c96c"
    sha256 cellar: :any,                 monterey:       "bbf993f54fce55bd59c3c7ec610809054147aff15a9da0fad51683da521487b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e450076019a1beb5dd3d176b2b6f60e903f8080afcb1b893f6d501c7035bdd"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.12"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/71/a5/d61e4263e62e6db1990c120d682870e5c50a30fb6b26119a214c7a014847/protobuf-5.27.2.tar.gz"
    sha256 "f3ecdef226b9af856075f28227ff2c90ce3a594d092c39bee5513573f25e2714"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  def install
    ENV.append_to_cflags "-DPB_ENABLE_MALLOC=1"
    venv = virtualenv_create(libexec, "python3.12")
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
    (testpath/"test.proto").write <<~EOS
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    EOS

    system Formula["protobuf"].bin/"protoc",
      "--proto_path=#{testpath}", "--plugin=#{bin}/protoc-gen-nanopb",
      "--nanopb_out=#{testpath}", testpath/"test.proto"
    system "grep", "Test", testpath/"test.pb.c"
    system "grep", "Test", testpath/"test.pb.h"
  end
end
