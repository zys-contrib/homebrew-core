class ZlibNgCompat < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.2.3.tar.gz"
  sha256 "f2fb245c35082fe9ea7a22b332730f63cf1d42f04d84fe48294207d033cba4dd"
  license "Zlib"
  head "https://github.com/zlib-ng/zlib-ng.git", branch: "develop"

  livecheck do
    formula "zlib-ng"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "76c20d6ed2c49ff701a6b6481a77f9552b483689c7a34ca80cf3ee81ea618983"
    sha256 cellar: :any,                 arm64_sonoma:  "ffb9478de009ee51ef72b0457eef3210c505d7fe905428df405227afb53f3833"
    sha256 cellar: :any,                 arm64_ventura: "47cee490e09b583e965247a94c0c7868e1a60fcb6c80096fd047b6be58c84ae3"
    sha256 cellar: :any,                 sonoma:        "2b33cae6f27b6bd9f0ae79614b9cada2d89710916c4fb111ae6faac9c59c48a9"
    sha256 cellar: :any,                 ventura:       "7e8ea237b3589fa3f07f71de4c11687d10efc1c7c8d0640ec5a1564e477bdd79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3eefb9467069e984bfcc3f1c2a18262fa424e56664a9c97631ca0ce7c045b35"
  end

  keg_only :shadowed_by_macos, "macOS provides zlib"

  on_linux do
    keg_only "it conflicts with zlib"
  end

  # https://zlib.net/zlib_how.html
  resource "homebrew-test_artifact" do
    url "https://zlib.net/zpipe.c"
    version "20051211"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    ENV.runtime_cpu_detection
    # Disabling new strategies based on Fedora comment on keeping compatibility with zlib
    # Ref: https://src.fedoraproject.org/rpms/zlib-ng/blob/rawhide/f/zlib-ng.spec#_120
    system "./configure", "--prefix=#{prefix}", "--without-new-strategies", "--zlib-compat"
    system "make", "install"
  end

  test do
    testpath.install resource("homebrew-test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", lib/shared_library("libz"), "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text)
    assert_equal text, pipe_output("./zpipe -d", compressed)
  end
end
