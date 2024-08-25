class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/refs/tags/1.5.1.tar.gz"
  sha256 "7456737a2e0fc17717ea2d80083cfcf04524abaa69b1eb79bded86b257398cd0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b8222c2ccc6966f22ab3a710201fefef9b3a445b076673ad3ac81e65bb572ba9"
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
