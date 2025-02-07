class Topgit < Formula
  desc "Git patch queue manager"
  homepage "https://github.com/mackyle/topgit"
  url "https://github.com/mackyle/topgit/archive/refs/tags/topgit-0.19.14.tar.gz"
  sha256 "0556485ca8ddf0cf863de4da36b11351545aca74fbf71581ffe9f5a5ce0718cb"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fe4b9aa22aa1c75a5718b0db398e1351457108d92b5414176e46cadca8a1aa47"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
