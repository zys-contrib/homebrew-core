class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.1.tgz"
  sha256 "e872623475d24028dcb29bf8301571450236045390d619a3e37b88014bd5fb68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb0febc6a7a94a23a8b6267071afa95947dcba833efbf93505994ac1cde8f012"
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
