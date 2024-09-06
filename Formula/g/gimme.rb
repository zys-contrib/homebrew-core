class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https://github.com/travis-ci/gimme"
  url "https://github.com/travis-ci/gimme/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "50c42ec01505bee0e5b60165a0f577fe1e08fe9278fe3fe4b073c521f781c61e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "915831c18b1257af25c9bfdac53e7ecc2a71de4cec44eaad8fa7f1766d6f45f5"
  end

  def install
    bin.install "gimme"
  end

  test do
    system bin/"gimme", "-l"
  end
end
