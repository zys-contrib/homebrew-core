class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.tar.gz"
  sha256 "096a12331959590f5879f1039b2b6e32c887be58069e3bf1589aee949a420f51"
  license "Zlib"

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "6ec25e39bf3112ac569ed2675e70d69cd813bb8348f6b5bc8acd30885b36f32d"
    sha256 cellar: :any,                 arm64_sonoma:   "9a10d891af8696c797c1cde1d7feb63308077f59bd01ef2f35cf93143d856352"
    sha256 cellar: :any,                 arm64_ventura:  "2117ba812cbfd0cbf35f01de5c340891f5a98c66c9483cb34b561572da885c1d"
    sha256 cellar: :any,                 arm64_monterey: "a5356da9dafc82e253b2fac3e9f5f1ef32be82f64c3fb8a90c0fec460ad65261"
    sha256 cellar: :any,                 sonoma:         "c6092653c90c43799ca8c38b40ea36c254c14a30bf5e866b6be628a097377979"
    sha256 cellar: :any,                 ventura:        "6adaf92aa28d53af0d328a5442ba1bd02037e11ae6648eb3289dd1f58c9b37bd"
    sha256 cellar: :any,                 monterey:       "0c41e0eb888fc35b4a19f99818e0238303b6d8bfaab9b0649046594f8967633d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2463b4ca7e9c39952ce9d60f4c52b3ebce242cdd783e78c95cea78e179e5880f"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.12"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/b1/a4/4579a61de526e19005ceeb93e478b61d77aa38c8a85ad958ff16a9906549/protobuf-5.28.2.tar.gz"
    sha256 "59379674ff119717404f7454647913787034f03fe7049cbef1d74a97bb4593f0"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
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
