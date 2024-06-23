class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/refs/tags/1.5.0.tar.gz"
  sha256 "f5ca4a688e9b97d0783b10a834e3563e3d881669c29f89135b5abffce631527a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8af6684c2a65280d090441f5dd9b323d566bef0f07d2bfd2a508729ee639c42c"
  end

  depends_on "lua"

  def install
    system "make"
    bin.install "fennel"

    lua = Formula["lua"]
    (share/"lua"/lua.version.major_minor).install "fennel.lua"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
