class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.6.tgz"
  sha256 "580238965025644e540030dc59b981e4561c5d6b357c75002c7ffccffc588dcc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "77d47cd5f9a0746ac7e0809e8149e5446f0fd46195d66df363b622b2ada69169"
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
