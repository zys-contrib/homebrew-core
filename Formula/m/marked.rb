class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.9.tgz"
  sha256 "42149915f12abada6fd5c21902f5282b2c02e3b7cbebfee55df7af9fb8b6831f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5e203d21717e05dcba4ab2965010293ebb16dc560a96017038f274fbd8951eb6"
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
