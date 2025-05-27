class Prettyping < Formula
  desc "Wrapper to colorize and simplify ping's output"
  homepage "https://denilsonsa.github.io/prettyping/"
  url "https://github.com/denilsonsa/prettyping/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "e8484492e3c704b2460a00b0e417a07ad7112b5f4ad9a211931ee031fe64b4b6"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "507cf7f326024d3e369d6dd816af6391849d3a6c03dd942c5be7df370856317d"
  end

  def install
    bin.install "prettyping"
  end

  test do
    system bin/"prettyping", "-c", "3", "127.0.0.1"
  end
end
