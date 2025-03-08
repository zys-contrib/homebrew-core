class Hr < Formula
  desc "<hr />, for your terminal window"
  homepage "https://github.com/LuRsT/hr"
  url "https://github.com/LuRsT/hr/archive/refs/tags/1.5.tar.gz"
  sha256 "d4bb6e8495a8adaf7a70935172695d06943b4b10efcbfe4f8fcf6d5fe97ca251"
  license "MIT"
  head "https://github.com/LuRsT/hr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2b4ca59ba24ac04e3a7c8d76f3a75b1ea8fb01f919e7a5ef7b7ee01a36820ac4"
  end

  def install
    bin.install "hr"
    man1.install "hr.1"
  end

  test do
    system bin/"hr", "-#-"
  end
end
