class Libcutl < Formula
  desc "C++ utility library"
  homepage "https://www.codesynthesis.com/projects/libcutl/"
  url "https://www.codesynthesis.com/download/xsd/4.2/libcutl-1.11.0.tar.gz"
  sha256 "bb78ff87d6cb1a2544543ffe7941f0aeb8f9dcaf7dd46e9acef3e032ed7881dc"
  license "MIT"
  head "https://git.codesynthesis.com/libcutl/libcutl.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "build2" => :build

  def install
    system "b", "configure", "config.install.root=#{prefix}"
    system "b", "install", "--jobs=#{ENV.make_jobs}", "-V"
    pkgshare.install "tests/re/driver.cxx" => "test.cxx"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"test.cxx", "-o", "test", "-L#{lib}", "-lcutl"
    system "./test"
  end
end
