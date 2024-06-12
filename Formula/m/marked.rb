require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-13.0.0.tgz"
  sha256 "4f745b70c992a1511efadf24f9b363fe4493d326c57faf657276104f4e24cc47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "717d409f830e2f01f5f209cd4273064d102e3e9ae919edd098c9bd82f81c1b49"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
