class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.1.tar.gz"
  sha256 "882cd8473ad932b24787e676a808e4fb29c12e086d20bcbfbacc66c183094b5c"
  license "Zlib"

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "4dda74ced165d82abc82f13baeb15b9d3598560c09b81587f185ff9f869b9718"
    sha256 cellar: :any,                 arm64_sonoma:  "324320a06e3f779104b027145321c2fc4bbbd879bceaf658f327e98e4f689a32"
    sha256 cellar: :any,                 arm64_ventura: "295498441bcdf15eb3aa2e231465426e0980c825ba59927a0cda38de0b6e0df2"
    sha256 cellar: :any,                 sonoma:        "3a2ea4468b72031cf014fe96b9f639328b4e4fcdacc8f8c3e6f94e93bafd4f8a"
    sha256 cellar: :any,                 ventura:       "2aba3891f33fc2ea0bf95d9394d6dcb82335e2707fda6c266416ea3efa45146d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d387808781feaf19ad9514de2bba60e7833af33ea648cd9d40458d84ddaa55b6"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.13"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/6a/bb/8e59a30b83102a37d24f907f417febb58e5f544d4f124dd1edcd12e078bf/protobuf-5.29.0.tar.gz"
    sha256 "445a0c02483869ed8513a585d80020d012c6dc60075f96fa0563a724987b1001"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
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
