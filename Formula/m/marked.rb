class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.3.tgz"
  sha256 "99e8254fb982bdc5e62f7b6301784482fd8632951fcb707839985e3b544fc38d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a444d04f5a4a55939470d6900e32326647495e13335c5915794db6acfc483e18"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end
