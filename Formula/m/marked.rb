class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-14.1.4.tgz"
  sha256 "fdd5f88e39297768b0a18b2b94a5da9abfd2abe4407bcfb44d1fc5d81d587c86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30a4eee412e3a26ffa373c91208f5333589dc1416863193b785794905aefaba3"
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
