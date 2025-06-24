class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-3.1.2.tgz"
  sha256 "d2c9d4399fc628076392b21237d97cd9574e96accca830c38f678efb1c0ba829"
  license "MIT"
  head "https://github.com/11ty/eleventy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ad4a19fb02401364c5066a30b5dd4fe0e3c01c0947fd8ddb39477d49f0593b9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"README.md").write "# Hello from Homebrew\nThis is a test."
    system bin/"eleventy"
    assert_equal "<h1>Hello from Homebrew</h1>\n<p>This is a test.</p>\n",
                 (testpath/"_site/README/index.html").read
  end
end
