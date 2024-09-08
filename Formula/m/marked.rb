class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-14.1.2.tgz"
  sha256 "a338f1e45653eab3ae97630f9395925a296d6c1467b0743af6b312528dcbbaa9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "500f609b60cc46b3b1341aac5061bd9db0a8676277cb52803fc25f3043dd617f"
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
