class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.11.tgz"
  sha256 "ceb989894e243b04249c188c42d45e18cdccf7eaa20e8bc227b2360b6555f3ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c6d52fac6bc809916e6b143c69210fbe49be3c7a62b9010bd2b829b18799b85c"
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
