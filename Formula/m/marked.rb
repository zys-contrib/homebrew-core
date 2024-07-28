require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-13.0.3.tgz"
  sha256 "d70b051b88307eea37ccccae7d3eed9bc6c1adac58b7d616afe26731f44d2b05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9916cd74a65354c3ffe6ba7128351022bfebc7313145ba33f950526a535c1799"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9916cd74a65354c3ffe6ba7128351022bfebc7313145ba33f950526a535c1799"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9916cd74a65354c3ffe6ba7128351022bfebc7313145ba33f950526a535c1799"
    sha256 cellar: :any_skip_relocation, sonoma:         "9916cd74a65354c3ffe6ba7128351022bfebc7313145ba33f950526a535c1799"
    sha256 cellar: :any_skip_relocation, ventura:        "9916cd74a65354c3ffe6ba7128351022bfebc7313145ba33f950526a535c1799"
    sha256 cellar: :any_skip_relocation, monterey:       "9916cd74a65354c3ffe6ba7128351022bfebc7313145ba33f950526a535c1799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b83f00d023ddba0a5ecbb97d11ede65fee2eb1a52ce2fd034b02ae10ee43236"
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
