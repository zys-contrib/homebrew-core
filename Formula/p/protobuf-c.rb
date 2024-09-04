class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c5683e989d7d421f4e8c786b622efb74902de0fc4d63c309a0a29fcf0125dd68"
    sha256 cellar: :any,                 arm64_ventura:  "499e2d1c7a3af86411cf00d0446eb8c6a8471bea8f0bedc7d91ada98136873f8"
    sha256 cellar: :any,                 arm64_monterey: "5b9e4d34c06dcb481778a7ef8fda75a041ee9cf1631b2ed123df4378d579af1d"
    sha256 cellar: :any,                 sonoma:         "25c9766b9b94866803cd88a2a5aca78dbbd37c90442c47e5122945a93bea8156"
    sha256 cellar: :any,                 ventura:        "fc8ba42f043b5908c81bc42abf4df0c8967f9c843dd67565dc3ac0eca9ab3284"
    sha256 cellar: :any,                 monterey:       "635a90818bc65fcdd4fa8aa73616448c6ff177538354eddee2b89c3e4b9f3026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "888a335ee29b8541eae39dbd2f47dad4c95dabf0a289a4f1752717bdd7467bc1"
  end

  head do
    url "https://github.com/protobuf-c/protobuf-c.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "protobuf"

  # Apply commits from open PR to support Protobuf 26.
  # PR ref: https://github.com/protobuf-c/protobuf-c/pull/711
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/e3acc96ca2a00ef715fa2caa659f677cad8a9fa0.patch?full_index=1"
    sha256 "3b564a971023d127bb7b666e5669f792c94766836ccaed5acfae3e23b8152d43"
  end
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/1b4b205d87b1bc6f575db1fd1cbbb334a694abe8.patch?full_index=1"
    sha256 "6d02812445a229963add1b41c07bebddc3437fecb2a03844708512326fd70914"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."

    testpath.glob("test.pb-c.*").map(&:unlink)
    system bin/"protoc-c", "test.proto", "--c_out=."
  end
end
