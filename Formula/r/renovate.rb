require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.12.0.tgz"
  sha256 "1cd27521ddd97146916f3204af9ee6bc14c90504ff25e2fd23488548fbeb22e4"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c78b493e3c025f3c89294461fc23f9fce42e7478b8e9e6a8bd2da4c02d96a7ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e86f62e927b0e996e31e3a25ab721078cb76e9af4a343c5fb5c334bbc69be2d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d3548be979410662ceff8cdc84ea67f2f1eb4e21f9271ad9e1a4021231bf84b"
    sha256 cellar: :any_skip_relocation, sonoma:         "497e77f0b8cc221a16d0501e459be96a6409f795d64a84c47bd7ba85c120609e"
    sha256 cellar: :any_skip_relocation, ventura:        "8145b66753b4a3ea360c8c3b2763b57456de5e998d7dd97949ca6f5f13f1097b"
    sha256 cellar: :any_skip_relocation, monterey:       "805956f04c2ed25569bdc0ddf345dbaa336f8fb6a0a3fd2fb005159480cab326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27600f66d87b45427ac1968d92571ddbf3eada6912f74165e12686f430856797"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
